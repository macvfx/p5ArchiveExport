# P5 Archive Export - Mac App User Guide

**Workflow Guide** | v1.5.5 | macOS 13.5 and later

---

## What Is This App?

P5 Archive Export is a native macOS application with three local workflows:

- `SQL Export` reads the Archiware P5 `resources.db` SQLite database and exports archive job data to CSV files.
- `Volume Export` uses local `nsdchat` to export per-volume tape or container inventories to TSV files, with optional archive-only filtering and optional `Full` to `Readonly` switching before export. It can also export a full volume list CSV.
- `Backup Export` creates compressed `.tar.gz` archives of the P5 `config/` and `log/` directories, suitable for regular backups and server migrations. It includes an Archive Index Inspector and optional clips exclusion.

**Important:** The volume and backup workflows are designed for local use on the Archiware P5 server. The SQL database is opened read-only. The optional volume-mode step can change eligible archive volumes from `Full` to `Readonly` if that setting is enabled. The backup archive requires admin privileges to read `/usr/local/aw/`.

Volume Export also carries a test panel that runs volume commands against a
remote P5 server over `awsock`. It is labelled `(v1.5 Test)` in the app and is
described under [Remote Volume Export (v1.5 Test)](#remote-volume-export-v15-test).

---

## Getting Started

### First Launch

1. Open **P5 Archive Export.app**
2. The main dashboard window appears with a top workflow switch for `SQL Export`, `Volume Export`, and `Backup Export`
3. Before running your first export, open **Settings** to configure your paths

### Opening Settings

- Click the **gear icon** in the toolbar, or
- Use the menu bar: **P5 Archive Export > Settings...** (Command + ,)

---

## Settings

Settings are organized into five tabs:

### SQL Export

| Setting | Description | Default |
|---------|-------------|---------|
| **Search Label** | Prefix used for output folder names (e.g., `ArchiveJobs_ResourcesDB-2025-01-15_140000`) | `ArchiveJobs_ResourcesDB` |
| **Minimum Job Size** | Only include archive jobs above this size threshold in the `archive-jobs-above-1gb` query. Choose from 512 MB, 1 GB, 5 GB, 10 GB, or 50 GB. It does not affect the charts, which describe every job | 1 GB |
| **CSV Delimiter** | Field separator for exported CSV files: Comma, Tab, or Semicolon | Comma |
| **Include all built-in queries** | Master toggle to include or exclude all 14 bundled SQL queries from each export run | On |
| **Include archive-jobs-above-1gb query** | Keep the primary archive-jobs-above-1gb query enabled even when all other built-in queries are turned off. This toggle is grayed out when the master toggle above is on (since it is already included). | On |
| **Also write chart data CSVs** | Per-period CSVs in plain numbers, for charting in a spreadsheet | On |
| **Also write an HTML dashboard** | One self-contained page of charts, opening anywhere the file reaches | On |
| **Also print that dashboard to PDF** | The same page printed to A4. The slowest of the three, since it runs a web view | Off |
| **Server Queries Folder** | Where the standalone export script on a P5 server reads its queries from, used by `Deploy to Server` | `/Library/Scripts/sql/sql_queries` |
| **Database Path** | Full path to the Archiware P5 `resources.db` file | `/usr/local/aw/config/joblog/resources.db` |
| **External SQL Directory** | Optional folder containing your own `.sql` query files | Empty |
| **Local SQL Output Directory** | Where SQL CSV exports are saved | `~/Documents/ArchiveCSV` |
| **Network Copy Destination** | Optional mounted path to copy SQL CSVs to after export | Empty |

**How these toggles work together:**

- **Default (both on):** All 14 built-in queries run. The "Include archive-jobs-above-1gb query" checkbox is grayed out because it is already included as part of the full set.
- **Only archive-jobs-above-1gb:** Uncheck "Include all built-in queries" first. The second checkbox becomes active. Leave "Include archive-jobs-above-1gb query" checked. Now only that single query will run (plus any external queries).
- **Only external queries:** Uncheck "Include all built-in queries", then uncheck "Include archive-jobs-above-1gb query". An orange warning will appear: *"All built-in queries are disabled. Only external queries will run."*
- **Re-enabling all queries:** First uncheck "Include archive-jobs-above-1gb query", then check "Include all built-in queries" back on. This restores the default state with all 14 built-in queries active.

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
| **Folder mode** | Choose a dated run folder for separate snapshots, or a standard `VolumeExport` folder for incremental runs | Dated run folder |
| **Export volume list CSV** | Exports a full p5 volume list CSV alongside per-volume TSVs | Off |
| **Switch Full to Readonly before export** | Attempts to change eligible archive volumes from `Full` to `Readonly` before inventory export | Off |
| **Sort by generation** | Organizes output into LTO generation subfolders when possible | On |
| **Overwrite files** | Allows existing files to be replaced during export | Off |

#### Remote Servers (v1.5 Test)

The last group in the Volume Export tab connects to a **different** P5 server and runs the same volume commands there. The app does this by calling the local `nsdchat` binary with a server argument, so the `nsdchat Path` above still has to point at a working local binary even when every command runs against a remote server. There is no REST API involved; the transport is Archiware's own `awsock` socket protocol.

The panel is labelled `(v1.5 Test)` in the app because it is a proving ground, not a finished workflow. Read the limits below before relying on it.

| Field | Description | Default |
|-------|-------------|---------|
| **Saved Server** | Picker listing saved server profiles. Appears once at least one profile is saved | - |
| **Server Name** | Label for the profile, shown in the picker and in status messages | Empty |
| **Host** | Hostname or IP address of the remote P5 server | Empty |
| **Port** | P5 socket port, not the web UI port | `9001` |
| **Username** | P5 user the commands run as | Empty |
| **Archive Index** | Recorded on the profile. Not yet used by any remote command | `Default-Archive` |
| **Password (stored in Keychain)** | Saved to the login Keychain, one item per profile. Never written to preferences | Empty |

**New**, **Save Server** and **Delete** manage profiles. Save is disabled until name, host, username and a numeric port are all filled in. Deleting a profile also removes its Keychain password.

Profiles are stored in the shared settings domain, so the menu bar app loads the same list. Only the window app shows this panel.

##### What the test buttons do

| Button | Action |
|--------|--------|
| **Test Local Volume List** | Lists volumes on the local server, to confirm the `nsdchat` path works before blaming the network |
| **Test Selected Remote Server** | Lists volumes on the selected remote server. Every other remote control stays hidden until this succeeds |
| **Export Remote Batch** | Exports the first 1 or 2 volumes from the fetched list. The batch size is capped at 2 in code, whatever the picker offers |
| **Fetch Selected Volume Details** | Reads usage, mode, state, barcode, label, media type, used size, last used and location for one volume |
| **Test Full -> Readonly** | Changes one remote volume from `Full` to `Readonly`. Enabled only when the fetched volume is currently `Full`. This writes to the remote server |
| **Export Selected Volume TSV** | Exports one volume inventory using the same six columns as a local run |

##### Where remote TSV files are written

**Remote exports do not come back to your Mac.** The **Remote Test Output Directory** field (default `/Users/Shared`) is a path *on the remote P5 server*, and that is where the files land. The app sends the destination as `localhost:/path`, and `localhost` is resolved by the P5 server at the far end of the socket, not by the Mac running the app. The Local Volume Output Directory, Network Copy Destination, Folder mode, generation sorting and overwrite settings all apply to local runs only; none of them affect a remote export.

This means the directory has to already exist on the remote server and be writable by the P5 user. Collecting the files afterwards is a separate step you do yourself.

### Backup

| Setting | Description | Default |
|---------|-------------|---------|
| **P5 Config Directory** | Path to the Archiware P5 config directory | `/usr/local/aw/config/` |
| **P5 Log Directory** | Path to the Archiware P5 log directory | `/usr/local/aw/log/` |
| **Exclude clips/preview folders** | Omit the large clips/preview folders from the backup archive | On |
| **Backup clips separately** | When clips are excluded, create a second archive containing discovered `clips`, `preview`, and `previews` folders from archive indexes | Off |
| **Admin Username** | macOS admin username for unattended scheduled backups | Empty |
| **Admin Password** | Stored in the macOS Keychain via the "Save to Keychain" button | Empty |
| **Local Backup Output Directory** | Where backup archives are saved | `~/Documents/P5Backup` |
| **Secondary Network Copy Destination** | Optional mounted path to copy the archive to after creation | Empty |

**Admin credentials:** The backup archive requires root read access to `/usr/local/aw/`. If admin credentials are stored in the Keychain, the tar command runs silently using those credentials. If no credentials are stored, the standard macOS admin password dialog appears each time. Stored credentials are required for unattended scheduled backups.

**Archive Index Inspector:** A manual "Scan" button discovers archive indexes via `nsdchat -c ArchiveIndex names` (or falls back to scanning the filesystem at `{config}/index/archive/` when P5 is stopped). Each discovered index shows its name, total size, and clips folder size.

**Clips backup flow:** Enable **Exclude clips/preview folders** to keep clips out of the main `p5_backup` archive. Then enable **Backup clips separately** if you still want a second `p5_backup_clips` archive containing only discovered `clips`, `preview`, and `previews` folders from the archive indexes.

### Automation

| Setting | Description | Default |
|---------|-------------|---------|
| **Scheduled Workflow** | Which workflow the timer runs: SQL Export, Volume Export, SQL + Volume, Backup Export, or All Workflows | SQL Export |
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
- `Backup Export`

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

The volume-list CSV can be imported with the TSV folder by P5 Archive Browser.
Browser 0.19 build 33 normalizes balanced SQL-style outer single quotes before
matching volume IDs, labels, and barcodes, preventing quoted metadata rows from
becoming separate zero-file tapes.

### Volume TSV Columns and Browser Compatibility

The current Volume Export requests `ppath size handle btime mtime`. P5 writes
the archive index path first, so every exported inventory uses this six-column
order:

```text
index path ⇥ ppath ⇥ size ⇥ handle ⇥ btime ⇥ mtime
```

This is the format currently supported by P5 Archive Browser. Browser retains
the index path and size; it accepts but does not yet persist the other four
fields. The same layout can also be created directly with:

```text
nsdchat -c Volume VOLUME_ID inventory localhost:/absolute/output.tsv \
  ppath size handle btime mtime
```

Archiware P5's Web UI can export an eight-column order containing `index path,
ppath, volumes, size, handle, btime, mtime, checksum`. We plan to test and
support that richer schema in Browser, then expand P5 Archive Export to match.
Until Browser's schema-aware importer ships, keep the current six-column output;
the eight-column order moves `size` from column 3 to column 4.

The implementation notes and end-to-end test sequence for that change are kept
with the source rather than here.

### Volume Export Naming

The app uses the p5 volume number as the base filename:

- `10001.tsv`
- `10001_BARCODE.tsv`
- `10001_BARCODE_suspect.tsv`

Placeholder barcode values such as `<empty>` fall back to the p5 volume number so files do not collide.

### Volume Export Output Structure

By default, each volume export creates a timestamped folder:

```
~/Documents/ArchiveTSV/
  VolumeExport-2026-03-25_113259/
    10001.tsv
    10002.tsv
    p5-volumes-list_2026-03-25_113259.csv
```

For incremental inventories, set **Folder mode** to **Standard folder**. The app then reuses one `VolumeExport` folder:

```
~/Documents/ArchiveTSV/
  VolumeExport/
    10001.tsv
    10002.tsv
```

With **Overwrite existing TSV files** off, later runs skip existing volume TSVs and add only new volume files. With overwrite on, matching volume TSVs are replaced in place.

If generation sorting is enabled, per-volume TSVs may be placed inside subfolders such as `LTO-5`, `LTO-6`, or `Unknown`.

### Remote Volume Export (v1.5 Test)

Everything above describes a local run. The `Remote Servers (v1.5 Test)` panel in
`Settings` > `Volume Export` runs the same volume commands against another P5
server instead. It is a test path, documented here so its behavior is not a
surprise, and it is not part of the normal export workflow.

**How the connection is made.** The app runs your local `nsdchat` binary with a
server argument, so the command is handled by the remote server's P5 instance:

```text
nsdchat -s awsock://USERNAME:PASSWORD@HOST:9001 -c Volume VOLUME_ID inventory \
  localhost:/Users/Shared/VOLUME_ID.tsv ppath size handle btime mtime
```

Port `9001` is the P5 socket port. The password is read from the Keychain when
the command runs; it is never stored in preferences and never appears in the
settings file. The column layout is identical to a local export, so the output
is readable by P5 Archive Browser on the same terms.

**Where the files go.** The `localhost:` prefix is resolved by the remote
server, so the TSV is written to the remote server's own disk. Nothing is
transferred to the Mac running the app. Set **Remote Test Output Directory** to
a path that already exists on the remote server and is writable by the P5 user.

**Order of operations.** Save a server profile, then run
**Test Selected Remote Server**. The metadata, mode-change and export controls
only appear after a volume list has been fetched successfully, because they work
from the names that fetch returned.

**Current limits.** Batch export is capped at two volumes. The archive-only
filter, naming mode, folder mode, generation sorting, overwrite handling,
network copy and volume-list CSV are all local-run settings and have no effect
on a remote export. The `Archive Index` field on a server profile is saved but
not yet used. SQL Export and Backup Export are local-only and have no remote
equivalent. Remote runs cannot be scheduled from the Automation tab.

## Charts

The `Charts` tab beside `Results` and `Log` shows how much has been archived over
time, read straight from the P5 database.

### What each chart shows

| Chart | What it answers |
|-------|-----------------|
| **Archived per week / month / quarter / year** | How much went to archive in each period. The picker switches the grain. |
| **Cumulative growth** | The running total month by month. |
| **Outcome by year** | Finished against incomplete volume, so a year where a lot did not complete is obvious. |
| **Where the volume sits** | How many jobs fall into each job-size range, and how much storage each range accounts for. |

Stat tiles above them give the totals, the busiest period and how many periods in
range had no archiving at all.

### Periods with no archiving

A period where nothing was archived is drawn as a **grey bar**, not left out.

This matters more than it sounds. A chart built only from periods that had
activity runs a straight line across a pause, which reads as steady throughput.
Archiving usually arrives in bursts, so the grey bars are often most of the
chart, and the shape of the real pattern depends on them being there.

A grey bar means "nothing was archived then". A coloured bar of zero height would
mean "a job ran and moved nothing", which is a different thing.

### Units

Sizes scale to whatever suits the data — TB for a large archive, GB or MB for a
small one — and the unit is named on the axis. Every value in one chart uses the
same unit, so bars can be compared by eye.

### Charting a folder of exported CSVs

If this Mac cannot reach the P5 server, `Open Export Folder…` reads a folder of
exported CSVs instead and draws the same charts from it. Point it at one of the
timestamped run folders.

Two things an export cannot tell the charts, both stated above them when they
apply:

- Exports made before version 1.5.3 have no `jobs-sum-per-week` file, so the
  weekly chart falls back to the jobs-above-1GB file and covers only jobs above
  that threshold. Re-exporting with a current version fixes it.
- Monthly figures come from `cumulative-storage-growth`, which counts finished
  jobs only, while the yearly and quarterly charts count every status. Their
  totals genuinely differ, and neither is wrong.

`Use the database` switches back.

---

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

### Chart Files

When the chart outputs are enabled in Settings, each run also writes:

```
    weekly_2025-01-15_140000.csv
    monthly_2025-01-15_140000.csv
    quarterly_2025-01-15_140000.csv
    yearly_2025-01-15_140000.csv
    size-range_2025-01-15_140000.csv
    dashboard_2025-01-15_140000.html
    dashboard_2025-01-15_140000.pdf
```

These are for charting rather than reading. Where the query CSVs write
`33.80 TB`, these write `33.8` — a value with the unit attached arrives in a
spreadsheet as text and cannot be summed or plotted. Every period is present,
including those with no archiving, with a `gap_filled` column marking the rows
that were filled in.

The HTML dashboard is a single self-contained page: no stylesheet, script or font
is fetched, so it opens on any machine the file reaches, with or without
internet. The PDF is that same page printed to A4.

They carry the run's timestamp like everything else, and are copied to the
network volume with the rest.

If a network copy path is configured and the volume is mounted, the exported files are also copied there.

---

## Backup Export Workflow

When `Backup Export` is selected, the main pane shows the backup run state and the last run results.

### Backup Export Behavior

1. Validates that the P5 config directory exists (log directory is optional)
2. Creates a timestamped output directory
3. Measures config and log directory sizes
4. Discovers archive indexes (via nsdchat CLI or filesystem scan)
5. Creates a compressed `.tar.gz` archive with admin privileges
6. Optionally creates a separate clips archive containing discovered `clips`, `preview`, and `previews` folders (only if clips are excluded and "Backup clips separately" is on)
7. Optionally copies the archive to a secondary mounted network path

### Backup Export Output Structure

```
~/Documents/P5Backup/
  P5Backup-2026-05-21_140000/
    p5_backup_2026-05-21_140000.tar.gz
    p5_backup_clips_2026-05-21_140000.tar.gz  (optional, clips-only archive)
```

The clips-only archive is created only when both clips exclusion and separate clips backup are enabled. If no clip or preview folders are found under `config/index/archive/`, the run records a clips-archive step warning instead of creating a tiny empty-looking archive.

### Backup Results Dashboard

After a backup completes, the dashboard shows:
- Config, log, and archive sizes with compression ratio
- Whether clips were excluded and/or backed up separately
- Archive index table with name, total size, and clips size
- Network copy status
- Step-by-step results with duration and any errors

---

## Bundled SQL Queries

The app ships with 14 built-in queries:

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
| `jobs-sum-per-week` | Archive volume per week, all statuses, with idle weeks present as zero rows |
| `jobs-throughput-analysis` | All finished jobs ranked by transfer speed (MB/s) |
| `recent-jobs-last-30-days` | Jobs from the last 30 days with status |
| `tape-utilization-summary` | Total jobs and data per LTO tape |
| `top-20-largest-jobs` | The 20 largest archive jobs by size |
| `yearly-status-summary` | Annual breakdown by job status with size totals |

### Reading the size columns

Queries that report a size emit it twice, in two columns:

- **A display column** with the unit in brackets, e.g. `Total Size (TB)`, whose value
  is formatted for reading: `33.80 TB`.
- **A numeric column** with a bare unit suffix, e.g. `Total TB`, whose value is a plain
  number: `33.8`.

Spreadsheets and charting tools need the numeric column — a value like `33.80 TB`
imports as text and cannot be plotted or summed. The display column is there for
reading the CSV directly.

Numeric columns are always added at the end of a query's column list, and the display
columns keep their original names and positions, so anything that imports these files
by column name is unaffected.

### Getting the Queries onto a P5 Server

The standalone export script runs whatever `.sql` files are in its own queries
folder on the server — usually `/Library/Scripts/sql/sql_queries/`. That folder is
not updated when the app is, so a server can keep producing the output of an
older version long after the app has moved on.

### Installing the queries with the package

The release ships **P5-Archive-Export-SQL-Queries-<version>.pkg** beside the disk
images. Double-click it and the queries are installed to
`/Library/Scripts/sql/sql_queries` on that machine. macOS asks for an
administrator password through its own dialog; nothing is typed into a terminal.

This is the recommended route for a P5 server, for two reasons beyond
convenience. The system installer is the audited way to write to a folder owned
by root, so no app has to hold privileges it otherwise never needs. And it leaves
a receipt, so a machine can be asked what it actually has:

```
pkgutil --pkg-info com.matx.p5archiveexport.sqlqueries
pkgutil --files   com.matx.p5archiveexport.sqlqueries
```

A copied folder cannot answer that question. A receipt can, which matters when a
server has been running unattended for a year and nobody remembers which query
set it carries.

The package version tracks the app version, so the two can be compared directly.
A new package is issued whenever the bundled queries change.

#### Deploying from the app instead

Set **Server Queries Folder** in `Settings ▸ SQL Export` to wherever that folder
is, then press **Deploy to Server**. The bundled `.sql` files are written
straight into it and the count is reported beside the button.

That works whenever the folder is one you can write to — the app running on the
P5 server itself with the folder opened up, or a mounted share that reaches it.

The default, `/Library/Scripts/sql/sql_queries`, is owned by root, and no app
running as an ordinary user can write there. Deploy will say so. In that case use
**Export Bundled Queries…**, which writes them to a folder you choose and reveals
them in Finder, then copy them across:

```bash
sudo cp /path/you/exported/*.sql /Library/Scripts/sql/sql_queries/
```

The app does not ask for administrator rights to do this itself.

Only the server-side script needs this. The app runs its own bundled copies, so
its exports are always current.

### Custom Queries

To add your own queries:

1. Create a folder for your `.sql` files (e.g., `~/Documents/P5Queries/`)
2. In Settings > SQL Export, set the **External SQL Directory** to that folder
3. Write standard SQL queries against the P5 `resources.db` schema
4. Use the placeholder `{{MIN_SIZE_KB}}` in your SQL to reference the configured minimum size threshold (value is in KB)

Custom queries with the same filename as a built-in query will override the built-in version.

---

## Shared Settings

Both P5 Archive Export (Mac) and P5 Archive Export (Menu Bar) share the same settings. Changes made in one app are immediately reflected in the other. The menu bar app opens its settings in a separate shared-settings window from the popover's **Settings...** gear button. You can use either app independently or run both simultaneously.

---

## Help Inside the App

The **Help** menu holds two windows.

| Item | Shortcut | What it shows |
|------|----------|---------------|
| **P5 Archive Export User Guide** | ⌘? | This guide, with a searchable list of its sections down the side |
| **What's New...** | - | The release notes: what changed in each version, in plain terms |

Both windows render the documents the app ships with - this guide and
`RELEASES.md` - rather than a separate copy written into the app, so the text
you read in the app is the text in the written guide. The search field matches
section headings and body text, including table cells and command examples.

Before 1.5.2 the Help menu had one item that opened the About box, and there was
no guide inside the app.

The menu bar app has no Help menu. Use the Mac app's guide, or the written
guides in the repository.

---

## Checking for Updates

**P5 Archive Export ▸ Check for Updates…** asks GitHub whether a newer release exists and
reports the result either way. The app also checks quietly at launch, at most once every
24 hours, and only says something when there is a newer version.

Nothing is downloaded or installed for you. The check compares version numbers and sends
no information about your Mac or your P5 server. Pre-release builds are not offered. When
a newer version is found, the alert offers a **Download** button that opens the release
page.

The menu bar app has the same command, as **Check for Updates…** at the bottom of its
popover.

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
| Backup archive creation failed | The admin password dialog was cancelled or incorrect. Store credentials in Settings > Backup for unattended use |
| Backup scheduled but no admin dialog | Store admin credentials in Settings > Backup > Admin Credentials so the tar command can run without an interactive prompt |
| Archive Index Inspector shows no indexes | Click "Scan" manually. If P5 is stopped, the scanner falls back to filesystem discovery at `{config}/index/archive/` |
| Permission denied | The app requires read access to `resources.db`. Run under a user account with appropriate file permissions |
