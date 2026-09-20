# P5 Archive Export 1.5.5

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**Deploy the queries to a P5 server, from the app.**

The standalone export script on a server runs whatever `.sql` files are in its own
queries folder, and that folder is not updated when this app is. A server can
therefore go on producing the output of an older version indefinitely — which is
how a duration calculation that wraps at 365 days stayed wrong on the server side
for months after it was fixed in the app.

This release ships an installer for them, beside the disk images:
**P5-Archive-Export-SQL-Queries-1.5.5.pkg**. Double-click it on the server and the
queries are installed to `/Library/Scripts/sql/sql_queries`. macOS asks for an
administrator password through its own dialog, and nothing is typed into a
terminal.

It leaves a receipt, so a server can be asked what it has rather than remembered:

```
pkgutil --pkg-info com.matx.p5archiveexport.sqlqueries
pkgutil --files   com.matx.p5archiveexport.sqlqueries
```

A copied folder cannot answer that question, which is the one worth asking of a
machine that has run unattended for a year. The package version tracks the app
version, and a new one is issued whenever the bundled queries change.

If you would rather not use an installer, or your destination is a mounted share,
`Settings ▸ SQL Export` also gains a **Server Queries Folder** path and a
**Deploy to Server** button that writes the queries straight into it. Both apps
have it.

## Version

1.5.5 rather than another build of 1.5.4, because an update check compares the
version string: a Mac already running 1.5.4 would not have been offered a second
1.5.4.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Release notes: https://github.com/macvfx/p5ArchiveExport/blob/main/RELEASES.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
