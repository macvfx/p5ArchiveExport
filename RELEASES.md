# Release Notes

Human-facing release notes, newest first. See `CHANGELOG.md` for the detailed,
per-change log.

---

## 1.5.5

### Deploying the queries to a P5 server

The standalone export script on a P5 server runs whatever `.sql` files are in its
own queries folder, and that folder is not updated when this app is. A server can
therefore go on producing the output of an older version indefinitely.

This release ships an installer package for them, beside the disk images:
**P5-Archive-Export-SQL-Queries-1.5.5.pkg**. Double-click it on the server and the
queries are installed to `/Library/Scripts/sql/sql_queries`. macOS asks for an
administrator password in its own dialog, and nothing is typed into a terminal.

It also leaves a receipt, so a server can be asked what it has rather than
remembered:

```
pkgutil --pkg-info com.matx.p5archiveexport.sqlqueries
```

A new package is issued whenever the bundled queries change.

If you would rather not use the installer, Settings gains a **Server Queries
Folder** path and a **Deploy to Server** button, which writes them straight into
that folder.

That works wherever you can write to the folder — the app running on the server
itself, or a mounted share that reaches it. The usual location,
`/Library/Scripts/sql/sql_queries`, is owned by root and no app running as you can
write there; Deploy says so plainly and gives you the one-line copy instead.

Both apps have it.

### Version

1.5.5 rather than another build of 1.5.4, because an update check compares the
version string.

---

## 1.5.4

### Charts

There is a Charts tab now, beside Results and Log. It shows how much was archived
per week, month, quarter or year, the running total over time, finished against
incomplete volume by year, and how much storage sits in each job-size range.

A period where nothing was archived is drawn as a grey bar rather than left out.
That sounds like a detail and is not: a chart built only from the periods that
had activity draws a straight line across a pause, which reads as steady
throughput. Archiving usually comes in bursts, so those grey bars are often most
of the chart.

Sizes scale to suit the data. An archive of a few terabytes reads in TB; one of a
few gigabytes reads in GB rather than as a column of 0.00 TB.

### Charts on the share, with every export

Each run can now also write, beside the CSVs it already writes:

- per-period CSVs in plain numbers, for charting in a spreadsheet
- a single HTML page of the charts, which fetches nothing and so opens on any
  machine the file reaches
- a PDF of that page

The first two are on by default, the PDF is off. All three are copied to the
network volume with everything else.

### Charts without the database

If the Mac cannot reach the P5 server, `Open Export Folder…` in the Charts tab
reads a folder of exported CSVs instead and draws the same charts from it.

Where an export cannot answer something, the charts say so rather than guessing:
exports made before 1.5.3 have no weekly file, so the weekly chart covers only
jobs above 1 GB until you re-export.

### Getting the queries onto a server

`Settings ▸ SQL Export ▸ Export Bundled Queries…` writes the bundled `.sql` files
to a folder you choose. If you run the standalone export script on a P5 server,
copy them into its queries folder — that folder is not updated when the app is,
and a server otherwise keeps producing the output of an older version.

### Menu bar

The popover says when anything was last archived, and its settings now reach
everything the main app's do.

### Version

1.5.4 rather than another build of 1.5.3, because an update check compares the
version string: a Mac already running 1.5.3 would not have been offered a second
1.5.3.

---

## 1.5.3

### Archive volume per week, and columns you can actually chart

Exports now carry a fourteenth query, `jobs-sum-per-week`: how much was archived
each week, with weeks that had no archiving present as zero rows rather than
missing. A gap in the record is the thing most likely to mislead — a chart drawn
from rows that exist will run a straight line across a pause and make it look
like steady throughput.

Every query that reports a size now writes it twice: once formatted for reading,
as `33.80 TB`, and once as a plain number, as `33.8`. Spreadsheets and charting
tools need the plain number — a value with the unit attached arrives as text and
cannot be plotted or summed. Columns with the unit in brackets, like
`Total Size (TB)`, are for reading; columns with a bare unit, like `Total TB`,
are for charting.

The new columns are added at the end and nothing that was there before has moved
or been renamed, so anything already importing these files — P5 Archive Browser,
Project Folder Tracker, your own spreadsheets — carries on unchanged.

### A charting tool for existing exports

`scripts/p5chart.py` turns either the P5 job database or a folder of exported
CSVs into charts and tidy spreadsheet-ready files. It works on exports already
sitting on your share, including ones made before this release.

---

## 1.5.2

### A real Help menu

Until now the Help menu held a single item, "P5 Archive Export Help", and it
opened the About box. There was no guide inside the app at all.

Help ▸ P5 Archive Export User Guide (⌘?) now opens the guide in its own window,
with a searchable list of sections down the side. Help ▸ What's New… opens these
release notes.

Both windows render the documents this app ships with, rather than a copy
retyped into the app, so what you read in the app is what the written guide
says. Update the guide, and the app updates with it.

### The remote-server panel is documented

Settings ▸ Volume Export ▸ Remote Servers has been in the app since 1.5, and was
never described anywhere you could reach. The guide now has a settings reference
for the panel and a workflow section for what it does.

Two things in it are worth knowing before you use it. It talks to the other P5
server by running your local `nsdchat` over Archiware's `awsock` protocol, not
over the REST API, so the nsdchat path still has to be right. And a remote
export is written to the remote server's own disk — the files do not come back
to your Mac, and the output directory you name has to already exist there.

---

## 1.5.1

### The update alert could be dismissed

Its OK button took several attempts to click. The alert attached itself to
whichever window happened to be key, including panels that take it with them
when focus moves, and the app did not come to the front first, so the first
click only activated it. The menu bar app was worst affected, having no ordinary
window.

### The version in the app is the version that was built

It came from a file edited by hand beside the project rather than from the
project itself, and had drifted. Two different builds had shipped calling
themselves 1.5 build 4.

---

## 1.5

### Backup Export

A third workflow beside SQL Export and Volume Export. It makes compressed
`.tar.gz` archives of the P5 `config/` and `log/` directories, for routine
backups and for server migrations. Clips and preview folders can be left out of
the main archive, and optionally written to a second archive of their own.

### Archive Index Inspector

In Settings, finds your archive indexes and reports their sizes, including the
clips and preview folders. It works from the filesystem when P5 is stopped.

### Volume Export

Exports one TSV inventory per tape or container using local `nsdchat`, with
optional archive-only filtering, an optional full volume-list CSV, optional
generation sorting, and an optional copy to a mounted network destination.
Eligible archive volumes can be switched from Full to Readonly first.

Folder mode chooses between a dated folder per run and one standard
`VolumeExport` folder for incremental runs.

### Automation covers every workflow

A schedule can run SQL Export, Volume Export, SQL + Volume, Backup Export, or
all workflows.

---

## 1.3

### About window

About P5 Archive Export opens a window with the app name, version, build number
and a link to code.matx.ca. The menu bar app shows the same information at the
foot of its Settings popover.

Version numbers shown in the app are now read from the app itself, so they stay
current.

---

## 1.2

### Clearer Settings

The four settings tabs moved from a flat list to bordered groups with headings.
Long paths can be scrolled and read in full, each path field says what it is
for, and every tab scrolls, so nothing becomes unreachable in a small window.

---

## 1.1

### Choosing which queries run

A single checkbox turns all 13 built-in queries on or off. The
archive-jobs-above-1gb query has its own toggle that still works when the others
are off, and a warning appears when both are off and only external queries would
run.

---

## 1.0

The first release: a windowed Mac app and a menu bar app, sharing one core.
SQL Export reads the P5 `resources.db` read-only and writes archive job data to
CSV, with 13 bundled queries and support for your own.
