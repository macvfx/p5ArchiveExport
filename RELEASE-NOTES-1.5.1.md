# P5 Archive Export 1.5.1

Both apps, Mac and menu bar. Universal, signed and notarized.

## Fixed

**The update alert could not be dismissed.** Its OK button took several attempts
to click. The alert was attached as a sheet to whichever window happened to be
key, including transient panels that take the sheet with them when focus moves,
and the app did not bring itself to the front before showing it, so the first
click was spent activating it rather than pressing the button. The menu bar app
was worst affected, because it has no ordinary window to attach anything to.

The fix is in the shared update-checker package, which both apps now use by
reference instead of carrying their own copy. That copy was why the problem
lasted: fixes made to the package never reached this app.

## Corrected

**The Mac app requires macOS 13.5, not macOS 12.** It has since it moved to the
shared update-checker package, which sets that floor, but the guide still said
Monterey. Nothing about the app changed here — only the documented requirement,
which was wrong. The menu bar app requires macOS 14, as before.

## Version

1.5.1 rather than another build of 1.5, because an update check compares the
version string: a Mac already running 1.5 would not have been offered a second
1.5. The version now comes from the project itself rather than from a file
edited by hand beside it, so the number in the app is the number that was built.

Guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_Mac.md
Menu bar guide: https://github.com/macvfx/p5ArchiveExport/blob/main/USER_GUIDE-P5_Archive_Export_MenuBar.md
