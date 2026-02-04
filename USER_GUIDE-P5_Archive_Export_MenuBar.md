# P5 Archive Export - Menu Bar App User Guide

**Version 1.1** | macOS 14 (Sonoma) and later

---

## What Is This App?

P5 Archive Export Menu Bar is a lightweight, always-available menu bar utility that reads the Archiware P5 `resources.db` SQLite database and exports archive job data to CSV files. It sits in your menu bar for quick access to export operations and scheduling, without occupying space in the Dock.

**Important:** This app must be run directly on the Archiware P5 server where the `resources.db` file is located (typically at `/usr/local/aw/config/joblog/resources.db`). The database is opened in read-only mode, so the app will never modify your P5 data.

---

## Getting Started

### First Launch

1. Open **P5 Archive Export MenuBar.app**
2. An archive box icon appears in the menu bar (top-right of screen)
3. No Dock icon is shown - the app lives entirely in the menu bar
4. Click the menu bar icon to open the popover

### Before Your First Export

Click the menu bar icon and expand the **Settings** section to configure:
- The path to your `resources.db` file
- Your desired output directory
- Optional network volume path
- Schedule preferences

---

## Menu Bar Popover

Click the archive box icon in the menu bar to open the popover window.

### Status Section

At the top of the popover you will see:
- **Current status** - Ready, Exporting, or the result of the last run
- **Last run info** - When the last export ran, how many CSVs were generated, and total row count
- **Next scheduled run** - When the next automatic export is due (if scheduling is enabled)

### Export Now Button

Click **Export Now** to immediately run all configured queries and generate CSV files. During an export:
- A progress indicator shows the current operation
- The name of the currently executing query is displayed
- The button is disabled until the export completes

### Settings Section

Expand the **Settings** section within the popover to configure:

| Setting | Description | Default |
|---------|-------------|---------|
| **Database Path** | Full path to the P5 `resources.db` file | `/usr/local/aw/config/joblog/resources.db` |
| **Output Directory** | Where CSV exports are saved locally | `~/Documents/ArchiveCSV` |
| **Network Volume** | Optional network path to copy CSVs to (leave empty to disable) | Empty |
| **SQL Directory** | Optional folder with custom `.sql` query files | Empty (built-in only) |
| **Search Label** | Prefix for output folder names | `ArchiveJobs_ResourcesDB` |
| **Minimum Size** | Only include jobs above this threshold | 1 GB |
| **CSV Delimiter** | Comma, Tab, or Semicolon | Comma |
| **Schedule** | Manual Only, Daily, Weekly, or Monthly with time selection | Manual Only |

---

## Schedule

When a schedule is configured, the app will automatically run exports at the specified time:

| Frequency | Runs at |
|-----------|---------|
| **Daily** | Every day at the configured time |
| **Weekly** | Once per week on the selected day and time |
| **Monthly** | Once per month on the selected day and time |

**Note:** The schedule only runs while the app is active in the menu bar. If you quit the app, scheduled exports will not fire until you relaunch it. For always-on scheduling, add the app to your **Login Items** (System Settings > General > Login Items).

---

## Output Structure

Each export creates a timestamped folder:

```
~/Documents/ArchiveCSV/
  ArchiveJobs_ResourcesDB-2025-01-15_140000/
    archive-jobs-above-1gb_2025-01-15_140000.csv
    top-20-largest-jobs_2025-01-15_140000.csv
    yearly-status-summary_2025-01-15_140000.csv
    ...
```

If a network volume path is configured and the volume is mounted, all CSV files are also copied there. If the volume is not mounted, the copy is silently skipped.

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
2. In the Settings section, set the **SQL Directory** to that folder
3. Write standard SQL queries against the P5 `resources.db` schema
4. Use the placeholder `{{MIN_SIZE_KB}}` in your SQL to reference the configured minimum size threshold (value is in KB)

Custom queries with the same filename as a built-in query will override the built-in version.

---

## Shared Settings

Both P5 Archive Export (Mac) and P5 Archive Export (Menu Bar) share the same settings file. Changes made in one app are immediately reflected in the other. You can use either app independently or run both simultaneously.

---

## Running at Login

To have the menu bar app start automatically when you log in:

1. Open **System Settings**
2. Go to **General > Login Items**
3. Click the **+** button under "Open at Login"
4. Navigate to and select **P5 Archive Export MenuBar.app**

This ensures exports stay on schedule even after a server restart.

---

## Log Files

Application logs are written to:

```
~/Library/Logs/P5ArchiveExport/export.log
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Menu bar icon not visible | Check if the icon is hidden behind the notch (on MacBook Pro) or collapsed by macOS. Try holding Command and dragging menu bar icons to rearrange |
| "Database not found" error | Verify the database path in Settings. Ensure the app is running on the P5 server |
| Empty CSV output | Check that archive jobs above the minimum size threshold exist in the database |
| Network copy skipped | The network volume is not mounted. Mount the volume and re-run the export |
| Scheduled export did not run | The app must be active in the menu bar. Add it to Login Items to ensure it starts at boot |
| Permission denied | The app requires read access to `resources.db`. Run under a user account with appropriate file permissions |
| App does not appear in Dock | This is by design. The menu bar app runs without a Dock icon. Use the menu bar icon to interact with it |
