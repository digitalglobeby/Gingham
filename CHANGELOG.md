# Changelog

Gingham follows semantic versioning: a new major version for changes that
break the API. A license key covers a major version (see LICENSING.md).

## 1.0.0

The first release as Gingham, a binary package for macOS 14, iOS and iPadOS
17 and later on Apple silicon. Gingham was NGTable (1.0 to 1.8): the engine
and its API are the same, renamed.

- **Free up to 10,000 rows a table**, for any use, commercial too. A license
  key, registered at launch with `GHLicense.register(_:)`, shows every row.
- **One table view for AppKit and UIKit**, drawn by the GPU: frozen columns
  and column groups, a summary row with formulas, row grouping with
  subtotals, filters and search, live updates, editing in place, and a
  selection that follows records across reloads and sorts.
- **Millions of rows** through a column source (`GHColumnSource`): sorting,
  search, column filters, totals, copy and export run on all cores, off the
  main thread.
- **Faster than NGTable 1.8.3** in number formatting, text layout, text
  sorts, CSV and Excel export, and drawing cells that look alike.

### Moving from NGTable

- The module is `Gingham` (and `GinghamICU`): `import Gingham`.
- Types begin with `GH` instead of `NG`: `NGTableView` is `GHTableView`,
  `NGTableColumn` is `GHTableColumn`, `NGCellValue` is `GHCellValue`, and so
  on. A search and replace of `NG` at the start of a type's name does it.
- Layouts saved with `autosaveName` stay.
