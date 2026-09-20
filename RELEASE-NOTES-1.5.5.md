# P5 Archive Export 1.5.5

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**Deploy the queries to a P5 server, from the app.**

The standalone export script on a server runs whatever `.sql` files are in its own
queries folder, and that folder is not updated when this app is. A server can
therefore go on producing the output of an older version indefinitely — which is
how a duration calculation that wraps at 365 days stayed wrong on the server side
for months after it was fixed in the app.

1.5.4 added a command to write the bundled queries to a folder so you could copy
them across yourself. This release finishes it. Set **Server Queries Folder** in
`Settings ▸ SQL Export`, press **Deploy to Server**, and the queries are written
straight into it.

That works wherever the folder is one you can write to: the app running on the P5
server itself, or a mounted share that reaches it.

The usual location, `/Library/Scripts/sql/sql_queries`, is owned by root, and no
app running as an ordinary user can write there. Deploy will tell you that rather
than reporting a bare permission error, and give you the one line that does work:

```bash
sudo cp /path/you/exported/*.sql /Library/Scripts/sql/sql_queries/
```

Both apps have the setting and the button.

## Version

1.5.5 rather than another build of 1.5.4, because an update check compares the
version string: a Mac already running 1.5.4 would not have been offered a second
1.5.4.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Release notes: https://github.com/macvfx/p5ArchiveExport/blob/main/RELEASES.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
