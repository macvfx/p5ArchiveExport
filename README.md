# P5 Archive Jobs CSV Export

**Usage guide for `archive-jobs-export-csv.sh`**

Copyright Mat X 2026

---

## What It Does

`archive-jobs-export-csv.sh` is a Bash script that runs on an Archiware P5 server to export archive job data from the P5 SQLite database (`resources.db`) to CSV files. It executes every `.sql` file in a queries directory, writes timestamped CSV output to a local volume, and copies the results to a network share.

This script was the original automation tool for tracking large archive jobs. It has since evolved into a pair of native macOS applications (see [Evolution](#evolution) below), but remains a functional standalone option for environments where a simple cron/launchd job is preferred over a GUI.

---

## Requirements

- macOS with Bash 3.2+
- SQLite3 (included with macOS)
- Read access to the P5 database at `/usr/local/aw/config/joblog/resources.db`
- SQL query files in `/Library/Scripts/sql/sql_queries/`
- A mounted network volume at `/Volumes/NAS`
- Local backup volume at `/Volumes/Backup/AW/ArchiveSQL`

---

## Configuration

All paths are hard-coded at the top of the script for launchd compatibility (no environment variables or user input):

| Variable | Value | Purpose |
|----------|-------|---------|
| `DB_PATH` | `/usr/local/aw/config/joblog/resources.db` | P5 SQLite database |
| `SQL_QUERIES_DIR` | `/Library/Scripts/sql/sql_queries` | Directory of `.sql` query files |
| `SOURCE_BASE` | `/Volumes/Backup/AW/ArchiveSQL` | Local output base directory |
| `SEARCH_LABEL` | `ArchiveJobs_ResourcesDB` | Prefix for timestamped run folders |
| `NETWORK_VOLUME` | `/Volumes/NAS` | Network share mount point |
| `DEST_DIR` | `/Volumes/NAS/ArchiveCSV` | Network destination for CSV copies |
| `LOG_DIR` | `/Users/Shared/ArchiveCSV/logs` | Log file location |

To change any path, edit the variable directly in the script.

---

## What It Does Step by Step

1. **Creates the log directory** and begins logging to `/Users/Shared/ArchiveCSV/logs/run.log`
2. **Checks the network volume** is mounted at `/Volumes/NAS` — exits with an error if not
3. **Checks freshness of existing CSVs** on the network volume — if the newest CSV is less than 24 hours old, the run is skipped (see [Staleness Check](#staleness-check) below). Use `--force` to bypass this check.
4. **Creates a timestamped run directory** under `SOURCE_BASE`, e.g.:
   ```
   /Volumes/Backup/AW/ArchiveSQL/ArchiveJobs_ResourcesDB-2026-02-03_140000/
   ```
5. **Runs every `.sql` file** found in `SQL_QUERIES_DIR` against the P5 database using `sqlite3`, writing each result as a CSV with headers:
   ```
   archive-jobs-above-1gb_2026-02-03_140000.csv
   jobs-by-client_2026-02-03_140000.csv
   ...
   ```
6. **Copies all generated CSVs** to the network volume at `/Volumes/NAS/ArchiveCSV/`
7. **Logs a summary** of how many files were copied

---

## Output Structure

```
/Volumes/Backup/AW/ArchiveSQL/
  ArchiveJobs_ResourcesDB-2026-02-03_140000/
    archive-jobs-above-1gb_2026-02-03_140000.csv
    jobs-by-client_2026-02-03_140000.csv
    yearly-status-summary_2026-02-03_140000.csv
    ...

/Volumes/NAS/ArchiveCSV/
    archive-jobs-above-1gb_2026-02-03_140000.csv   (flat copy)
    jobs-by-client_2026-02-03_140000.csv
    ...
```

Local output is organized into timestamped subdirectories. The network copy is a flat directory — each run overwrites files with the same query name from previous runs (filenames include timestamps, so in practice each run adds new files).

---

## Running the Script

### Manual execution

```bash
sudo bash /path/to/archive-jobs-export-csv.sh
```

To bypass the staleness check and force a fresh export:

```bash
sudo bash /path/to/archive-jobs-export-csv.sh --force
```

The short form `-f` is also accepted.

Root or equivalent permissions may be needed to read `/usr/local/aw/config/joblog/resources.db`.

### Automated scheduling with launchd

Create a launchd plist (e.g., `/Library/LaunchDaemons/com.matx.archive-csv-export.plist`) to run the script on a schedule:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.matx.archive-csv-export</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Library/Scripts/archive-jobs-export-csv.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/archive-csv-export.stdout</string>
    <key>StandardErrorPath</key>
    <string>/tmp/archive-csv-export.stderr</string>
</dict>
</plist>
```

Load and start:

```bash
sudo launchctl load /Library/LaunchDaemons/com.matx.archive-csv-export.plist
```

---

## Staleness Check

Before generating any CSVs, the script checks whether the existing files on the network volume (`/Volumes/NAS/ArchiveCSV/`) are still fresh. It finds the newest `.csv` file by modification time and compares its age against a 24-hour threshold (`MAX_AGE_SECONDS=86400`).

| Condition | Behaviour |
|-----------|-----------|
| Newest CSV is **less than 24 hours old** | Run is skipped — logs the file name and age, exits cleanly |
| Newest CSV is **more than 24 hours old** | CSVs are considered stale — proceeds with regeneration |
| **No CSVs** exist on the network volume | Proceeds with generation (first run) |
| `--force` / `-f` flag is passed | Staleness check is skipped entirely |

This prevents redundant exports when the script is triggered more frequently than once per day (e.g., by launchd retries or manual runs). The log will show either a "fresh / skipping" or "stale / regenerating" message so you can confirm what happened.

---

## Log File

All output is logged to:

```
/Users/Shared/ArchiveCSV/logs/run.log
```

Each run is delimited by `========== RUN START ==========` and `========== RUN END ==========` markers with timestamps on every line.

---

## Adding SQL Queries

Place any `.sql` file in `/Library/Scripts/sql/sql_queries/` and the script will pick it up automatically on the next run. Each file is executed against the P5 `resources.db` database with CSV headers enabled.

Queries should be single-statement SELECT queries. Multi-statement files will execute but only the last statement's output is captured in the CSV.

---

## Error Handling

The script uses `set -e` — any command failure causes an immediate exit. Specific checks:

- **Network volume not mounted** — logs an error and exits before any queries run
- **No `.sql` files found** — logs an error and exits
- **SQLite errors** — `set -e` causes the script to abort on any query failure

---

## Evolution

This project started as a single shell script and grew into a suite of native macOS applications.

### Stage 1: Shell Script

`archive-jobs-export-csv.sh` was the original tool — a straightforward Bash script designed to be run manually or via launchd. It handled the core workflow: run SQL queries against the P5 database, export to CSV, copy to a network share. All configuration was hard-coded, which made it reliable for unattended scheduling but required editing the script to change any setting.

A second variant (`archive_csv_sync.sh`) was created with slightly different paths and labels for a different deployment environment, highlighting the limitation of hard-coded configuration.

### Stage 2: Native Mac App (P5 Archive Export)

The shell script was rebuilt as a native SwiftUI application (**P5 Archive Export**) targeting macOS 12+. The core workflow remained the same, but the app added:

- A full GUI with dashboard, settings panel, query browser, results table, and log viewer
- Configurable settings (database path, output directory, network volume, size threshold, CSV delimiter, schedule) persisted in UserDefaults — no more editing scripts
- 13 bundled SQL queries (up from the handful used by the shell script), including new analytical queries for throughput analysis, storage growth trends, and size distribution
- A built-in scheduler with daily, weekly, and monthly options
- Read-only SQLite access via the C API for safe operation against a live P5 database
- Real-time progress reporting during exports
- RFC 4180 compliant CSV output with configurable delimiters
- Graceful handling of unmounted network volumes (warning instead of hard failure)

### Stage 3: Menu Bar App (P5 Archive Export MenuBar)

A companion menu bar utility was built for macOS 14+, sharing the same core library (**P5ExportCore**) as the windowed app. The menu bar app provides:

- An always-available archive box icon in the menu bar with no Dock presence
- A popover interface for quick status checks and one-click exports
- Compact inline settings
- The same scheduling engine as the windowed app

Both apps share settings via a common UserDefaults suite, so changes in one are reflected in the other. They can be run independently or side by side.

### Architecture

```
archive-jobs-export-csv.sh          (standalone shell script)
        |
        v
P5ExportCore                        (shared Swift package)
   |              |
   v              v
P5Window          P5MenuBar
(Mac app)         (Menu bar app)
```

The shell script remains available for minimal environments or as a reference implementation. The Mac apps are distributed as signed `.app` bundles and `.dmg` installers.
