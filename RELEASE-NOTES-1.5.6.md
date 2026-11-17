# P5 Archive Export 1.5.6

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**resources.db that can't be opened in place is read from a temporary copy.**

`resources.db` is a write-ahead-log database. When it has no `-shm` file beside it
(P5 stopped, or the file copied without its companions), SQLite opens it without
complaint and then fails on the first read, which showed up as "unable to open
database file" on a file that was plainly there.

The app now falls back to a temporary copy of `resources.db` with its `-wal` and
`-shm`, reads that, and deletes it when the run ends. The original is never
touched and the copy cannot be written to. The copy is made only after a direct
read has failed, it checks free disk space first, and the run log says when one
was used.

A new **If it can't be opened** setting, in both apps, chooses between
**Use a temporary copy if needed** (the default) and **Read in place only**,
which never copies. Choose the second for a very large database.

The fallback cannot help when your user is not allowed to read the file at all;
that is a permissions problem.

**Settings opens on the section for the workflow you are in.**

In the Mac app, Settings opens on SQL Export, Volume Export or Backup to match the
top workflow switch, every time it is opened. The main window now reopens on the
workflow it was last on.

## Also

**What's New is a short list of highlights**, with buttons for the full release
notes and the user guide.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
