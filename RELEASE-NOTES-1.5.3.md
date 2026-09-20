# P5 Archive Export 1.5.3

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**Archive volume per week.** A fourteenth built-in query, `jobs-sum-per-week`,
reports how much was archived each week.

Weeks with no archiving appear as zero rows rather than being left out. That is
the point of it: a chart drawn from only the weeks that had activity runs a
straight line across a pause and makes it look like steady throughput. The
monthly file still behaves that way, and the weekly one does not.

Each week is identified by its start date, a Monday, rather than a week number.
Week numbering conventions disagree with each other, and a date does not.

**Columns you can actually chart.** Every query that reports a size now writes
it twice: once formatted for reading, as `33.80 TB`, and once as a plain number,
as `33.8`.

A value with the unit attached arrives in a spreadsheet as text. It cannot be
summed, averaged or plotted, and a chart built from it is either empty or wrong.
The plain number can be used directly.

The two are told apart by the column heading. A unit in brackets, like
`Total Size (TB)`, is formatted for reading. A bare unit, like `Total TB`, is a
number.

The new columns are added at the end, and no existing column has been renamed,
moved or removed. Anything already reading these files — P5 Archive Browser,
Project Folder Tracker, your own spreadsheets — is unaffected.

## Fixed

**Job durations longer than a year were reported wrongly** by the server-side
copy of the `archive-jobs-above-1gb` query. It counted days in a way that wraps
at 365, so a 400-day job was reported as 35 days. The app's own copy was
corrected some time ago; the two have now been brought back into step.

## Also included

A charting tool, `scripts/p5chart.py`, that turns either the P5 job database or
a folder of exported CSVs into charts and spreadsheet-ready files. It works on
exports already sitting on your share, including ones made before this release.

## If you use the standalone export script

The queries the app ships with are also kept in this repository, under
`sql_queries/`. The shell script runs whatever is in
`/Library/Scripts/sql/sql_queries/` on the P5 server, so the updated files have
to be copied there before a scheduled export produces any of the above.

## Version

1.5.3 rather than another build of 1.5.2, because an update check compares the
version string: a Mac already running 1.5.2 would not have been offered a second
1.5.2.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Release notes: https://github.com/macvfx/p5ArchiveExport/blob/main/RELEASES.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
