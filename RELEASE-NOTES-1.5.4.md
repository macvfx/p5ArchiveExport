# P5 Archive Export 1.5.4

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**Charts.** There is a Charts tab now, beside Results and Log: how much was
archived per week, month, quarter or year, the running total over time, finished
against incomplete volume by year, and how much storage sits in each job-size
range.

A period where nothing was archived is drawn as a grey bar rather than left out.
That sounds like a detail and is not. A chart built only from the periods that
had activity draws a straight line across a pause, and reads as steady
throughput. Archiving usually arrives in bursts, so those grey bars are often
most of the chart, and the real shape depends on them being there.

Sizes scale to suit the data. An archive of a few terabytes reads in TB; one of a
few gigabytes reads in GB, rather than as a column of `0.00 TB`.

**Charts on the share, with every export.** Each run can now also write, beside
the CSVs it already writes:

- per-period CSVs in plain numbers, for charting in a spreadsheet
- a single HTML page of the charts, which fetches nothing and so opens on any
  machine the file reaches, with or without internet
- a PDF of that page

The first two are on by default, the PDF is off. All three are copied to the
network volume with everything else.

**Charts without the database.** If the Mac cannot reach the P5 server,
`Open Export Folder…` reads a folder of exported CSVs instead and draws the same
charts from it.

Where an export cannot answer something, the charts say so rather than guessing.
Exports made before 1.5.3 have no weekly file, so the weekly chart covers only
jobs above 1 GB until you re-export; and the monthly figures count finished jobs
only, while the yearly and quarterly charts count every status.

**Getting the queries onto a server.** `Settings ▸ SQL Export ▸ Export Bundled
Queries…` writes the bundled `.sql` files to a folder you choose.

If you run the standalone export script on a P5 server, copy them into its
queries folder. That folder is not updated when the app is, so a server can keep
producing the output of an older version long after the app has moved on.

**The menu bar popover** says when anything was last archived, and its settings
now reach everything the main app's do.

## Documented

Both user guides now describe the charts, the chart outputs and the query export.
They open inside the app from the Help menu.

## Version

1.5.4 rather than another build of 1.5.3, because an update check compares the
version string: a Mac already running 1.5.3 would not have been offered a second
1.5.3.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Release notes: https://github.com/macvfx/p5ArchiveExport/blob/main/RELEASES.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
