# P5 Archive Export

Native macOS tools for exporting Archiware P5 data.

This repo currently contains two companion apps that share a core Swift package:

- `P5Window`: full windowed app for SQL export and volume export workflows
- `P5MenuBar`: lightweight menu bar app for quick runs and always-on scheduling
- `P5ExportCore`: shared export, scheduling, logging, and volume-export logic

## Current Capabilities

- SQL export from `resources.db` to CSV using built-in and external SQL queries
- Local-only volume export using `nsdchat`
- Optional archive-volume filtering
- Optional switch of `Full` archive volumes to `Readonly` before export
- Per-volume TSV inventory export
- Optional export of a full p5 volume list CSV
- Optional secondary network-copy destination for both SQL and volume exports
- Shared automation settings that can run `SQL Export`, `Volume Export`, or `Both`

## Workflow Model

The app is now organized around workflows instead of generic settings buckets:

- `SQL Export`
- `Volume Export`
- `Automation`
- `Advanced`

In the main app, `SQL Export` and `Volume Export` are separate top-level modes.
In the menu bar app, both workflows have their own manual run button and status area.

## Volume Export Naming

Volume TSVs use the p5 volume number as the base filename:

- no barcode: `10001.tsv`
- with barcode: `10001_BARCODE.tsv`
- suspect volume: `10001_BARCODE_suspect.tsv`

Placeholder barcode values such as `<empty>` fall back to the p5 volume number.

## Docs

- [Mac app guide](./USER_GUIDE-P5_Archive_Export_Mac.md)
- [Menu bar guide](./USER_GUIDE-P5_Archive_Export_MenuBar.md)

## Next Planned Step

The current remote-development branch is proving `awsock`-based remote volume operations and is expected to evolve into a separate remote-focused app direction: `P5 Archive Remote`.
