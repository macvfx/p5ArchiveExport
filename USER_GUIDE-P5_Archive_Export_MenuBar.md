# P5 Archive Export - Menu Bar App User Guide

**Workflow Guide** | macOS 14 (Sonoma) and later

---

## What Is This App?

P5 Archive Export Menu Bar is a lightweight, always-available menu bar utility for the same two local workflows as the main app:

- `SQL Export` from `resources.db` to CSV
- `Volume Export` from local `nsdchat` to per-volume TSV inventories

It sits in your menu bar for quick access to manual runs, workflow status, and scheduling, without occupying space in the Dock.

**Important:** This first-pass volume workflow is local-only and intended to run on the P5 server. The SQL export is read-only, but the optional volume-mode step can change eligible archive volumes from `Full` to `Readonly` if that setting is enabled.

---

## Getting Started

### First Launch

1. Open **P5 Archive Export MenuBar.app**
2. An archive box icon appears in the menu bar (top-right of screen)
3. No Dock icon is shown - the app lives entirely in the menu bar
4. Click the menu bar icon to open the popover

### Before Your First Export

Click the menu bar icon and expand the **Settings** section to configure:
- SQL export paths and options
- Volume export paths and options
- Automation target and schedule

---

## Menu Bar Popover

Click the archive box icon in the menu bar to open the popover window.

### Status Sections

At the top of the popover you will see:
- A separate status card for `SQL Export`
- A separate status card for `Volume Export`
- Last run info for each workflow
- The next scheduled run and which workflow target the timer is set to

### Manual Run Buttons

The popover includes two manual actions:

- `Run SQL`
- `Run Volume`

During a run:
- A progress indicator shows the current operation
- The current query or current volume is displayed
- Both buttons are disabled until the active run completes

### Settings Section

Expand the **Settings** section within the popover to configure:

#### SQL Export

- Database path
- External SQL directory
- Built-in query toggle
- Local SQL output folder
- Network copy destination
- CSV delimiter
- Search label

#### Volume Export

- `nsdchat` path
- Local volume output folder
- Network copy destination
- Naming mode
- Archive-only toggle
- Export volume list CSV
- Switch `Full` to `Readonly`
- Sort by generation
- Overwrite files

#### Automation

- Scheduled workflow target: `SQL Export`, `Volume Export`, or `Both`
- Frequency
- Time

---

## Schedule

When a schedule is configured, the app will automatically run the selected workflow target at the specified time:

| Frequency | Runs at |
|-----------|---------|
| **Daily** | Every day at the configured time |
| **Weekly** | Once per week on the selected day and time |
| **Monthly** | Once per month on the selected day and time |

**Note:** The schedule only runs while the app is active in the menu bar. If you quit the app, scheduled exports will not fire until you relaunch it. For always-on scheduling, add the app to your **Login Items** (System Settings > General > Login Items).

---

## Output Structure

SQL export creates a timestamped folder:

```
~/Documents/ArchiveCSV/
  ArchiveJobs_ResourcesDB-2025-01-15_140000/
    archive-jobs-above-1gb_2025-01-15_140000.csv
    top-20-largest-jobs_2025-01-15_140000.csv
    yearly-status-summary_2025-01-15_140000.csv
    ...
```

Volume export creates a separate timestamped folder, for example:

```
~/Documents/ArchiveTSV/
  VolumeExport-2026-03-25_113259/
    10001.tsv
    10002.tsv
    p5-volumes-list_2026-03-25_113259.csv
```

If a network copy path is configured and mounted, the exported files are also copied there. If the volume is not mounted, the copy is skipped with a warning.

### Volume Export Naming

- no barcode: `10001.tsv`
- with barcode: `10001_BARCODE.tsv`
- suspect volume: `10001_BARCODE_suspect.tsv`

Placeholder barcode values such as `<empty>` fall back to the p5 volume number.

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
2. In the Settings section under **SQL Export**, set the **SQL Directory** to that folder
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
| `nsdchat` not found | Verify the `nsdchat` path under Volume Export settings |
| Empty CSV output | Check that archive jobs above the minimum size threshold exist in the database |
| Empty or unexpected TSV output | Check the archive-only filter, volume state, and whether `nsdchat` can read that volume locally |
| Network copy skipped | The network copy destination is not mounted. Mount the volume and re-run the export |
| Scheduled export did not run | The app must be active in the menu bar. Add it to Login Items to ensure it starts at boot |
| Permission denied | The app requires read access to `resources.db`. Run under a user account with appropriate file permissions |
| App does not appear in Dock | This is by design. The menu bar app runs without a Dock icon. Use the menu bar icon to interact with it |
