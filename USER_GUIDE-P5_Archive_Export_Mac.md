# P5 Archive Export - Mac App User Guide

**Workflow Guide** | macOS 12 (Monterey) and later

---

## What Is This App?

P5 Archive Export is a native macOS application with two local workflows:

- `SQL Export` reads the Archiware P5 `resources.db` SQLite database and exports archive job data to CSV files.
- `Volume Export` uses local `nsdchat` to export per-volume tape or container inventories to TSV files, with optional archive-only filtering and optional `Full` to `Readonly` switching before export.

**Important:** This first-pass volume workflow is designed for local use on the Archiware P5 server. The SQL database is opened read-only, but the optional volume-mode step can change eligible archive volumes from `Full` to `Readonly` if that setting is enabled.

---

## Getting Started

### First Launch

1. Open **P5 Archive Export.app**
2. The main dashboard window appears with a top workflow switch for `SQL Export` and `Volume Export`
3. Before running your first export, open **Settings** to configure your paths

### Opening Settings

- Click the **gear icon** in the toolbar, or
- Use the menu bar: **P5 Archive Export > Settings...** (Command + ,)

---

## Settings

Settings are organized into four tabs:

### SQL Export

| Setting | Description | Default |
|---------|-------------|---------|
| **Search Label** | Prefix used for output folder names (e.g., `ArchiveJobs_ResourcesDB-2025-01-15_140000`) | `ArchiveJobs_ResourcesDB` |
| **Minimum Job Size** | Only include archive jobs above this size threshold. Choose from 512 MB, 1 GB, 5 GB, 10 GB, or 50 GB | 1 GB |
| **CSV Delimiter** | Field separator for exported CSV files: Comma, Tab, or Semicolon | Comma |
| **Include all built-in queries** | Master toggle to include or exclude all 13 bundled SQL queries from each export run | On |
| **Include archive-jobs-above-1gb query** | Keep the primary archive-jobs-above-1gb query enabled even when all other built-in queries are turned off. This toggle is grayed out when the master toggle above is on (since it is already included). | On |
| **Database Path** | Full path to the Archiware P5 `resources.db` file | `/usr/local/aw/config/joblog/resources.db` |
| **External SQL Directory** | Optional folder containing your own `.sql` query files | Empty |
| **Local SQL Output Directory** | Where SQL CSV exports are saved | `~/Documents/ArchiveCSV` |
| **Network Copy Destination** | Optional mounted path to copy SQL CSVs to after export | Empty |

**How these toggles work together:**

- **Default (both on):** All 13 built-in queries run. The "Include archive-jobs-above-1gb query" checkbox is grayed out because it is already included as part of the full set.
- **Only archive-jobs-above-1gb:** Uncheck "Include all built-in queries" first. The second checkbox becomes active. Leave "Include archive-jobs-above-1gb query" checked. Now only that single query will run (plus any external queries).
- **Only external queries:** Uncheck "Include all built-in queries", then uncheck "Include archive-jobs-above-1gb query". An orange warning will appear: *"All built-in queries are disabled. Only external queries will run."*
- **Re-enabling all queries:** First uncheck "Include archive-jobs-above-1gb query", then check "Include all built-in queries" back on. This restores the default state with all 13 built-in queries active.

Each path field has:
- A **green checkmark** or **red X** indicating whether the path exists
- A **Browse...** button to select the path using a file picker

### Volume Export

| Setting | Description | Default |
|---------|-------------|---------|
| **nsdchat Path** | Full path to the local `nsdchat` binary | `/usr/local/aw/bin/nsdchat` |
| **Local Volume Output Directory** | Where per-volume TSV exports are saved | `~/Documents/ArchiveTSV` |
| **Network Copy Destination** | Optional mounted path to copy volume TSVs and volume-list CSVs to | Empty |
| **Naming Mode** | Controls whether filenames include mode/date suffixes for non-readonly volumes | `Volume + Barcode` |
| **Archive volumes only** | Limits the run to archive volumes only | On |
| **Export volume list CSV** | Exports a full p5 volume list CSV alongside per-volume TSVs | Off |
| **Switch Full to Readonly before export** | Attempts to change eligible archive volumes from `Full` to `Readonly` before inventory export | Off |
| **Sort by generation** | Organizes output into LTO generation subfolders when possible | On |
| **Overwrite files** | Allows existing files to be replaced during export | Off |

### Automation

| Setting | Description | Default |
|---------|-------------|---------|
| **Scheduled Workflow** | Which workflow the timer runs: SQL Export, Volume Export, or Both | SQL Export |
| **Frequency** | How often to automatically run the export: Manual Only, Daily, Weekly, or Monthly | Manual Only |
| **Time** | Hour and minute (in 15-minute intervals) for the scheduled run | 02:00 |
| **Day of Week** | (Weekly only) Which day of the week to run | Monday |
| **Day of Month** | (Monthly only) Which day of the month to run (1-28) | 1st |

A status indicator shows whether the scheduler is active and when the next run is due.

**Note:** The schedule only runs while the app is open. If you quit the app, scheduled exports will not fire until you relaunch it.

### Advanced

- **Log File** location is displayed with an **Open in Finder** button
- **Reset All Settings** restores every setting to its default value

---

## Using the Dashboard

### Top Workflow Switch

At the top of the window you can switch between:

- `SQL Export`
- `Volume Export`

Each workflow has its own status, output location, and manual run action.

### SQL Export Sidebar - Query List

The left sidebar shows all discovered SQL queries:
- **Built-in** queries are bundled with the app (marked with a label)
- **External** queries are loaded from your custom SQL directory

If an external query has the same filename as a built-in one, the external version takes priority.

### Toolbar

| Button | Action |
|--------|--------|
| **Export Now** (play icon) | Runs the currently selected workflow |
| **Open Output** (folder icon) | Opens the current workflow's local output directory in Finder |
| **Settings** (gear icon) | Open the Settings window |

### Progress

During an SQL export, a progress bar appears showing:
- Overall completion percentage
- The name of the currently executing query

### SQL Results Tab

After an export completes, the Results tab shows a table with:
- Query name
- Status (success/failure)
- Number of rows and columns returned
- Execution time

### SQL Log Tab

The Log tab provides a live, scrollable view of all activity:
- **INFO** - normal operations (export started, query completed, files written)
- **WARN** - non-fatal issues (network volume not mounted, empty result set)
- **ERROR** - failures (database not found, SQL syntax error)

Use the filter buttons to show only specific log levels.

---

## Volume Export Workflow

When `Volume Export` is selected, the main pane shows the volume-export run state and the last per-volume results list.

### Volume Export Behavior

- Fetches the p5 volume list using local `nsdchat`
- Filters to archive volumes if that setting is enabled
- Optionally switches eligible `Full` archive volumes to `Readonly`
- Exports one TSV inventory file per targeted volume
- Optionally exports a full volume list CSV
- Optionally mirrors exported files to a secondary mounted network path

### Volume Export Naming

The app uses the p5 volume number as the base filename:

- `10001.tsv`
- `10001_BARCODE.tsv`
- `10001_BARCODE_suspect.tsv`

Placeholder barcode values such as `<empty>` fall back to the p5 volume number so files do not collide.

### Volume Export Output Structure

Each volume export creates a timestamped folder:

```
~/Documents/ArchiveTSV/
  VolumeExport-2026-03-25_113259/
    10001.tsv
    10002.tsv
    p5-volumes-list_2026-03-25_113259.csv
```

If generation sorting is enabled, per-volume TSVs may be placed inside subfolders such as `LTO-5`, `LTO-6`, or `Unknown`.

## SQL Output Structure

Each export creates a timestamped folder:

```
~/Documents/ArchiveCSV/
  ArchiveJobs_ResourcesDB-2025-01-15_140000/
    archive-jobs-above-1gb_2025-01-15_140000.csv
    top-20-largest-jobs_2025-01-15_140000.csv
    yearly-status-summary_2025-01-15_140000.csv
    ...
```

If a network copy path is configured and the volume is mounted, the exported files are also copied there.

---

## Bundled SQL Queries

The app ships with 13 built-in queries:

| Query | Description |
|-------|-------------|
| `archive-jobs-above-1gb` | All archive jobs above the configured size threshold with duration, throughput, and tape details |
| `cumulative-storage-growth` | Monthly running total of archived data over time |
| `failed-incomplete-jobs-detail` | All failed or incomplete jobs with error context |
| `jobs-by-client` | Archive jobs grouped by client name |
| `jobs-longest-running` | Top 20 longest-running archive jobs with throughput |
| `jobs-quarterly-summary` | Quarterly rollup with job counts and success rates |
| `jobs-size-distribution-buckets` | Jobs categorized into size buckets (1-5 GB, 5-10 GB, etc.) |
| `jobs-stale-incomplete` | Jobs started more than 7 days ago that never completed |
| `jobs-throughput-analysis` | All finished jobs ranked by transfer speed (MB/s) |
| `recent-jobs-last-30-days` | Jobs from the last 30 days with status |
| `tape-utilization-summary` | Total jobs and data per LTO tape |
| `top-20-largest-jobs` | The 20 largest archive jobs by size |
| `yearly-status-summary` | Annual breakdown by job status with size totals |

### Custom Queries

To add your own queries:

1. Create a folder for your `.sql` files (e.g., `~/Documents/P5Queries/`)
2. In Settings > SQL Export, set the **External SQL Directory** to that folder
3. Write standard SQL queries against the P5 `resources.db` schema
4. Use the placeholder `{{MIN_SIZE_KB}}` in your SQL to reference the configured minimum size threshold (value is in KB)

Custom queries with the same filename as a built-in query will override the built-in version.

---

## Shared Settings

Both P5 Archive Export (Mac) and P5 Archive Export (Menu Bar) share the same settings. Changes made in one app are immediately reflected in the other. You can use either app independently or run both simultaneously.

---

## Log Files

Application logs are written to:

```
~/Library/Logs/P5ArchiveExport/export.log
```

Open this location from Settings > Advanced > **Open in Finder**.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Database not found" error | Verify the database path in Settings > SQL Export. Ensure the app is running on the P5 server |
| `nsdchat` not found | Verify the path in Settings > Volume Export and confirm the app is running on the P5 server |
| Second volume export failed because the file already exists | Turn on Overwrite or change naming mode; placeholder barcodes such as `<empty>` already fall back to the p5 volume number |
| Empty CSV output | Check that archive jobs above the minimum size threshold exist in the database |
| Empty or unexpected TSV output | Check the targeted volume state, archive-only filter, and whether the volume inventory is accessible through local `nsdchat` |
| Network copy skipped | The network destination is not mounted. Mount the volume and re-run the export |
| Scheduled export did not run | The app must be running for schedules to fire. It does not run in the background when quit |
| Permission denied | The app requires read access to `resources.db`. Run under a user account with appropriate file permissions |
