# Changelog

Gingham follows semantic versioning: a new major version for changes that
break the API. A license key covers a major version (see LICENSING.md).

## 1.1.0

- **Text for cells without a value**: a column's `emptyText` (or
  `showingEmptyCells(as:)`) shows dimmed text, such as `NULL`, in its cells
  without a value. Copies, exports and searches still see an empty cell;
  VoiceOver reads the text.
- **Fixed**: on the iPad and iPhone, an empty table's text wraps instead of
  being cut to its first line.
- **Fixed**: a cell that shows its column's empty text flashes when it gets
  a value, as an empty cell does.
- **Fixed**: in the iOS simulator, a resized header (an iPad rotated, the
  sidebar shown) is drawn again instead of keeping its older frame.

## 1.0.2

- **Conditional formats on numbers shown as text**: data bars, color scales
  and text colors now show on cells whose numbers the app writes as its own
  text (a database's exact digits, its own notation) and sorts by value.
- **Fixed**: on the Mac, a table could keep showing an older frame until the
  next change, for example a header at the widths before its columns were
  fitted. Such a frame is now drawn again.

## 1.0.1

- **Faster with an app's own data**: the table reads an app's values
  faster for export, copy, column widths and scrolling (export of 200,000
  rows of 12 columns 20% faster).
- **Lighter live feeds**: on the Mac, a feed keeps the main thread a third
  to two thirds less busy, and a quieter one shows new values 6–8 ms sooner;
  flashes of changed values take half the frames on 120 Hz displays.
- **Faster text sorts of an app's own data**: about 20% for 10 million
  rows.
- **Less memory for sorted and searched huge tables** (about 10% less a
  row).

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
