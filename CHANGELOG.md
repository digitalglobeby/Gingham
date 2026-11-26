# Changelog

Gingham follows semantic versioning: a new major version for changes that
break the API. A license key covers a major version (see LICENSING.md).

## 1.2.1

A window with a table resizes as fast as the pointer moves. No API changes.

- **Live resizing follows the pointer**: dragging the edge of a window with
  a large table applied the new size up to half a second late on the Mac.
  Each step of the resize now draws without waiting, and the table is never
  shown stretched.
- **The table stays live while a window fills the screen**: during the
  green button's Fill and the full-screen animation, the table now shows its
  updates. (While a window zooms after a double click on its title bar,
  macOS pauses every app's drawing.)

## 1.2.0

Live updates take less of the main thread and the GPU, a table that can't
be seen takes less memory, and fixes to sorting, summaries and editing. No
API changes.

### Faster and leaner

- **Less main-thread time for live updates**: a batch of row updates does
  less work for each changed cell, and no longer goes over every cell in
  view, which counts most in large windows and busy feeds.
- **Unchanged cells stay as they are**: when rows are updated, their cells
  whose values didn't change keep what was drawn of them, also when the
  rows move in a live sort, a filter or a group.
- **Faster changing numbers**: numbers that change in place, such as a
  feed's prices, are laid out for their cells on all cores, and a stream of
  new values no longer crowds out the other text the table has laid out.
- **Less memory when a table isn't visible**: a second after a table can no
  longer be seen (its window minimized, covered or hidden, the table hidden
  or out of its window), it gives back the memory of its drawn frames. It
  draws at once when it shows again.
- **Less GPU time for row backgrounds**, in the default rounded style too;
  frames look the same.
- **Measured**: in the open bench's 3840 × 2160-point table on a MacBook Pro
  (M1 Max, 120 Hz), the 1,000,000-row trade feed takes 61% of the main thread
  instead of 80% with 1.1.4, the order book 38% instead of 46% and the wide
  live trades 47% instead of 51%, at 120 frames a second with both; the live
  trades stay at about a third (37%, 35% with 1.1.4). One set of 3 runs each
  ([1.2.0](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0356.md),
  [1.1.4](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-25-0100.md)).

### Fixed

- A sort by a number and then text, or by text with a comparison other than
  the default, no longer loses rows or shows some twice where Foundation's
  comparison contradicts itself (names in capitals with Ё or Й, Greek with
  tonos).
- Text where Foundation's comparison contradicts itself sorts the same
  whatever order the data source gives its rows in, and faster.
- A summary formula's minimum and maximum of a column are right after rows
  are removed or moved.
- A row added without a sort value while the live sort holds the rows (the
  pointer over them, a large batch placed in the background) goes to its
  place instead of staying at the end.
- Totals kept up to date by targeted updates no longer drift from the exact
  sum after many updates.
- `GHDataTable`: a `Decimal` such as 0.07 is exactly 0.07 in filters and
  exports, an edit writes the `Decimal` its digits say, and an edit to a
  number a `Decimal` can't hold is refused instead of crashing.
- The focused cell follows its record across `reloadData()` also when the
  first row has no identity.
- `isSearchingRows` and `isBusy` end when the data source is released
  during a large table's search.

### Documentation

- One reference for macOS and iOS: members only iOS has get pages of their
  own, and each page names the platforms that have it. Getting Started is
  written for the binary package, and the articles say what an app can rely
  on: what is read when and on which thread, costs in time and memory, and
  limits.

## 1.1.4

- **Less GPU time for large tables**: the table takes less GPU time of its
  own to draw large tables, and their frames look the same. The window
  server's time to show the window isn't part of it.

## 1.1.3

- **Sorting again is almost instant for values that hardly repeat too**:
  sorting a column of names or accounts again, after a sort by another
  column, takes almost no time. A million rows: 0.12–0.13 s, now 0.02 s
  (MacBook Pro M1 Max, Release). When the language changes, the column is
  sorted from its values again.

## 1.1.2

- **Faster sorts of values that repeat**: sorting a column whose values
  repeat is several times faster, and sorting the same column again is
  almost instant. A million rows by a column of about 500 values: 0.22 s,
  now 0.10 s; sorted again, 0.15 s, now 0.01–0.02 s (MacBook Pro M1 Max,
  Release). Column sources sort so too.

## 1.1.1

- **Fixed**: apps on Xcode 26.0–26.3 (Swift 6.2) build with the frameworks;
  with 1.0.0–1.1.0 they didn't compile.

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
