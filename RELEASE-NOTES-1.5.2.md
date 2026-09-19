# P5 Archive Export 1.5.2

Both apps, Mac and menu bar. Universal, signed and notarized.

## New

**The Help menu opens help.** It held one item, "P5 Archive Export Help", and it
opened the About box — an icon, a version number and a link. The guides existed
only in the repository, so anyone running the app had no way to reach them.

Help ▸ P5 Archive Export User Guide (⌘?) now opens the guide in its own window,
with a searchable list of its sections down the side. The search matches body
text, table cells and command examples, not only headings.

Help ▸ What's New… opens the release notes.

Both windows render the documents the app ships with rather than a copy written
into the app, so the text on screen is the text in the written guide.

The menu bar app has no Help menu and is unchanged here.

## Documented

**The remote-server panel, which shipped in 1.5 and was never described.**
Settings ▸ Volume Export ▸ Remote Servers connects to another P5 server and runs
the same volume commands there. The guide now covers it: every field, what each
test button does, and its current limits.

Two things in it are worth knowing before you use it. It reaches the other
server by running your local nsdchat over Archiware's awsock protocol on port
9001 — not over the REST API — so the nsdchat path still has to be correct. And
a remote export is written to the remote server's own disk: the files do not
come back to your Mac, and the output directory has to already exist there.

## Version

1.5.2 rather than another build of 1.5.1, because an update check compares the
version string: a Mac already running 1.5.1 would not have been offered a
second 1.5.1.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Release notes: https://github.com/macvfx/p5ArchiveExport/blob/main/RELEASES.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
