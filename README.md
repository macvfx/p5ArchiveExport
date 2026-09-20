# P5 Archive Export

Two macOS apps, and an example script, for exporting and backing up Archiware P5 data. *P5 Archive Export* is a Mac and Menu bar tool for exporting important Archiware P5 archive data. (See also code.matx.ca and https://github.com/macvfx/archiware)

This repo contains two companion apps that share a core Swift package:

- `P5Window`: full windowed app with three workflows (SQL Export, Volume Export, Backup Export)
- `P5MenuBar`: lightweight menu bar app for quick runs and always-on scheduling
- `P5ExportCore`: shared export, scheduling, logging, volume-export, and backup logic

## Current Capabilities (v1.5.3)

### SQL Export
- Export from `resources.db` to CSV using 14 built-in and/or external SQL queries
- Configurable CSV delimiter, size threshold, and search label
- Optional secondary network-copy destination

### Volume Export
- Local volume discovery and per-volume TSV inventory export using `nsdchat`
- Optional archive-volume filtering
- Optional switch of `Full` archive volumes to `Readonly` before export
- Optional export of a full p5 volume list CSV
- Optional secondary network-copy destination
- Optional organization by LTO generation

- Remote servers (`v1.5 Test`): the same volume commands run against another P5
  server by way of local `nsdchat` over Archiware's `awsock` protocol, not the
  REST API. Remote exports are written to that server's own disk and are not
  transferred back. See the Mac app guide.

### Backup Export
- Compressed `.tar.gz` archive of the P5 `config/` and `log/` directories
- Option to exclude clips/preview folders (can be tens or hundreds of GB)
- Option to backup clips separately in a second archive
- Archive Index Inspector: discovers indexes via `nsdchat -c ArchiveIndex names` with filesystem fallback
- Admin credential storage in macOS Keychain for unattended scheduled backups
- Optional secondary network-copy destination

### Automation
- Shared schedule that can run SQL Export, Volume Export, SQL + Volume, Backup Export, or All Workflows
- Daily, Weekly, or Monthly frequency with configurable time

## Workflow Model

The app is organized around three workflows:

- `SQL Export` — database analysis CSVs
- `Volume Export` — per-volume inventory TSVs and volume list CSV
- `Backup Export` — compressed config/log archives (.tar.gz)

In the main app, these are separate top-level modes with a segmented picker.
In the menu bar app, each workflow has its own manual run button and status area.

## Volume Export Naming

Volume TSVs use the p5 volume number as the base filename:

- no barcode: `10001.tsv`
- with barcode: `10001_BARCODE.tsv`
- suspect volume: `10001_BARCODE_suspect.tsv`

Placeholder barcode values such as `<empty>` fall back to the p5 volume number.

## Backup Export Output

Each backup creates a timestamped folder:

```
~/Documents/P5Backup/
  P5Backup-2026-05-21_140000/
    p5_backup_2026-05-21_140000.tar.gz
    p5_backup_clips_2026-05-21_140000.tar.gz  (if clips backed up separately)
```

## Help and Docs

The Mac app carries its own help. `Help` > `P5 Archive Export User Guide` (⌘?)
opens the guide in a window with a searchable section list, and
`Help` > `What's New...` opens the release notes. Both render the documents
below, bundled into the app, so the app and the written guides say the same
thing.

- [Mac app guide](./USER_GUIDE-P5_Archive_Export_Mac.md)
- [Menu bar guide](./USER_GUIDE-P5_Archive_Export_MenuBar.md)
- [Release notes](./RELEASES.md)

## Next Planned Step

The current remote-development branch is proving `awsock`-based remote volume operations and is expected to evolve into a separate remote-focused app direction: `P5 Archive Remote`.
