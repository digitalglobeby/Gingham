<h1 align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/digitalglobeby/Gingham/main/Assets/logo-dark.svg">
    <img src="https://raw.githubusercontent.com/digitalglobeby/Gingham/main/Assets/logo-light.svg" alt="Gingham" width="420">
  </picture>
</h1>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue" alt="macOS 14+">
  <img src="https://img.shields.io/badge/iOS%20%2F%20iPadOS-17%2B-blue" alt="iOS and iPadOS 17+">
  <img src="https://img.shields.io/badge/license-free%20up%20to%2010%2C000%20rows-lightgrey" alt="License: free up to 10,000 rows">
</p>

A fast table view for business data on the Mac, iPad and iPhone:
NSTableView's API, drawn by the GPU, free up to 10,000 rows a table.

- **A live order book of 200,000 rows** (about 243,500 changes a second, a
  2040 × 1080-point window):
  Gingham presents 120 frames a second with its main thread 36% busy and the
  Mac drawing 1.8 W. The fastest NSTableView we could write applies 80
  updates a second, at 95% and 4.6 W.
- **1,000,000 rows sorted by a text column**: 0.19 s. NSTableView, tuned or
  not: about 8 s (the typical one with the app frozen meanwhile).
- **Measured by an open benchmark** you can run yourself, including where
  Gingham isn't ahead.

https://github.com/user-attachments/assets/09160daf-4d3b-414d-9f89-58f1b99af4fa

![Gingham, NSTableView, NSTableView in its cell-based mode and SwiftUI Table with rows identified by position showing the same live order book](Assets/comparison.png)

The same live order book in Gingham 1.2.0, in NSTableView as apps typically
write it, in its cell-based mode tuned by hand and in SwiftUI's Table with
rows identified by their position, its fastest way we found (moments of a
recording, each window cut to its columns). The numbers in the windows were
measured live; the table under Benchmarks gives the medians of quiet runs.

## Features

A table view for business data on the Mac, iPad and iPhone, drawn by the
GPU, with an API that mirrors `NSTableView`, so apps migrate without
reworking their patterns. One `GHTableView` class works in AppKit and in
UIKit, with the same data source and delegate; on the iPad and iPhone it
takes touches, the pointer, a hardware keyboard and VoiceOver as the
system's own controls do. What is the Mac's for now is listed under
[Documentation](#documentation).

- **Frozen columns** at the leading and trailing edges, and **column groups**
  under a common header.
- **Summary row**: sums, averages, counts, minimums and maximums, value filters
  and **formulas** over other columns (e.g. ROI as a ratio of sums), for all
  rows, the selected rows or all except the selected ones. Large tables are
  summarized in the background.
- **Row grouping** by column values, several levels deep, under collapsible
  header rows with row counts and subtotals.
- **Search and filters** that hide rows without touching the data source.
- **Row identity**: the selection follows the same records when data is sorted
  or refreshed.
- **Live data**: targeted updates (`reloadData(forRowIndexes:columnIndexes:)`,
  inserts, removes, moves, batched with `beginUpdates()`/`endUpdates()`) cost
  what changed; the table keeps the rows sorted itself as values change
  (`sortsRows`), or `reorderRows(from:to:)` re-sorts without reading the rows
  again.
- **Tens of millions of rows** on the Mac: a table of 10,000,000 rows sorts
  by text in about 2 seconds (M1 Max). With a column source
  (`GHColumnSource`), the table's sort, search and totals read your data on
  all cores, off the main thread, and keep no values.
- **Text sorts like Finder**, in `localizedStandardCompare`'s order, a million
  texts in about 0.2 seconds in the background, for every European language,
  Cyrillic, Greek, Hebrew, Arabic, Devanagari, kana, Han and Hangul; the
  optional [GinghamICU](GinghamICU.md) library adds ICU's collation for Thai
  and for Chinese texts with many readings.
- **NSTableView's patterns**: the same data source, delegate, sort
  descriptor and notification names, a diffable data source like
  `NSTableViewDiffableDataSource`, and an adapter for an existing
  `NSTableViewDataSource` (these two on the Mac).
- **Context menus** built by the app, with Finder's rules for which rows a
  click is for.
- **Column customization**: resize, move, hide and show columns, saved and
  restored.
- Values as text, numbers, currencies, percentages, dates, check marks,
  colored **tags**, icon **marks**, **sparklines** (lines, areas, bars, wins and
  losses), **links**, **buttons**, **progress bars**, **ratings**, and
  **pictures and videos** by URL (loaded, cached and played under the pointer
  by the table); text that **wraps**, rows as high as it.
- Native feel: overlay scrollers, elastic scrolling, Liquid Glass summary bar
  on macOS 26, dark mode, accent colors, keyboard navigation, type select,
  copying to spreadsheets, VoiceOver.
- **On the iPad and iPhone**: momentum scrolling, taps that select and act like clicks,
  editing in place, context menus on a long press, swipe actions, columns
  resized and moved by a finger, filters and choices in popovers, drag and
  drop, export to the share sheet, the pointer's hover, a hardware keyboard,
  VoiceOver's data table, and the summary row above the home indicator.

Your app owns the data. The table sorts the rows itself (`sortsRows`, in the
background for large tables) or leaves sorting to your app like
`NSTableView`, and your app performs the actions of its buttons and menus.

In SwiftUI on the Mac, `GHDataTable` works like `Table` (on the iPad it
comes next; until then wrap `GHTableView` in a `UIViewRepresentable`):

```swift
GHDataTable(campaigns, selection: $selection) {
    GHDataColumn("Name", value: \.name)
    GHDataColumn("Spend", value: \.spend, format: .currency(code: "USD"), summary: .aggregate(.sum))
}
```

## Requirements

- A Mac with macOS 14 or later, Apple silicon only, like macOS 27 (the
  frameworks are arm64); Liquid Glass on macOS 26 and later
- iOS and iPadOS 17 or later (the table view in UIKit, on the iPad and the
  iPhone)
- Swift 6.2 or later (Xcode 26 or later)
- On the iOS simulator, the frameworks are arm64 only (Apple silicon): builds
  for Any iOS Simulator Device need x86_64 excluded
  (`EXCLUDED_ARCHS[sdk=iphonesimulator*] = x86_64`)

## Installation

In Xcode, choose **File > Add Package Dependencies**, enter the repository's
URL, and add the `Gingham` library to your app target. In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/digitalglobeby/Gingham", from: "1.2.1"),
],
targets: [
    .target(name: "MyApp", dependencies: ["Gingham"]),
]
```

For ICU's collation keys (Thai, Chinese text with many words read otherwise,
or ICU's own order), also add the optional `GinghamICU` library, `.product(name: "GinghamICU", package: "Gingham")` (about 9 MB
in a Mac app, 5 MB in an iPhone or iPad app, see [GinghamICU](GinghamICU.md)). Apps without it don't carry its ICU.

### Versions

Gingham follows semantic versioning, with one rule for enums: a minor
version may add cases to the public enums that describe values, formats,
filters and summaries (`GHValueFormat`, `GHColumnFilter`, `GHCellValue`,
`GHAggregate` and the like), such as a new kind of filter or format. Keep a
`default` in a `switch` over them, and updates won't stop your code from
compiling. Only `GHColumnItem`,
`GHDataColumnItem`, `GHColumnPin` and `GHColumnVisibility.State` keep their
cases until the next major version.

> [!TIP]
> Gingham is a binary framework built with library evolution: its enums may
> get new cases, so a `switch` over one needs `@unknown default`.
> `GHColumnItem`, `GHDataColumnItem`, `GHColumnPin` and
> `GHColumnVisibility.State` are `@frozen` and switch without it. So are
> `GHCellValue` and `GHNamedColor` (since 1.0.1, so that an app makes values
> as fast as Gingham does), but a minor version may still add cases to them,
> and a `switch` over them without a `default` would then stop compiling:
> keep one.

## Quick start

```swift
import AppKit
import Gingham

struct Campaign {
    var id: String
    var name: String
    var spend: Double
}

@MainActor
final class CampaignTableData: GHTableViewDataSource {
    var campaigns: [Campaign] = []

    func numberOfRows(in tableView: GHTableView) -> Int {
        campaigns.count
    }

    func tableView(_ tableView: GHTableView, valueFor column: GHTableColumn, row: Int) -> GHCellValue {
        let campaign = campaigns[row]
        switch column.id {
        case "id": return .text(campaign.id)
        case "name": return .text(campaign.name)
        case "spend": return .number(campaign.spend)
        default: return .empty
        }
    }
}

final class CampaignsViewController: NSViewController {
    private let data = CampaignTableData()
    private let table = GHTableView(frame: .zero)

    override func loadView() {
        table.columns = [
            .column(GHTableColumn("name", title: "Campaign", width: 240, pin: .leading)),
            .column(GHTableColumn("spend", title: "Spend", width: 120, alignment: .automatic,
                                  format: .currency(code: "EUR"), summary: .aggregate(.sum))),
        ]
        table.rowIdentifierColumnID = "id"   // The selection follows the same campaigns.
        table.autosaveName = "Campaigns"     // The user's columns are remembered.
        table.dataSource = data
        view = table
    }

    func show(_ campaigns: [Campaign]) {
        data.campaigns = campaigns
        table.reloadData()                   // Always right after changing the data.
    }
}
```

On the iPad the same data source makes the table; put it in a
`UIViewController` (`view = table`, or as a subview pinned to the edges:
it keeps its summary row above the home indicator by itself). What the Mac
does with the mouse the iPad does by touch:

| On the Mac | On the iPad |
| --- | --- |
| Click, Command- and Shift-click | Tap (Command and Shift with a hardware keyboard) |
| Double click | Double tap (edits an editable cell) |
| Right-click menu: `tableView(_:menuForRows:clickedRow:column:)` returns an `NSMenu` | Long press: the same method returns a `UIMenu` |
| Trackpad swipe across a row | Finger swipe (where the table can't scroll further sideways) |
| Dragging a column's edge or title | The same, by a finger |
| Filter button, Option-Down Arrow | The header menu's Filter item, the filter button of a filtered column |
| `pasteboardWriterForRow`, `validateDrop`, `acceptDrop` | `itemsForBeginning`, `dropSessionDidUpdate`, `performDrop` (like `UITableView`'s) |
| `exportDocument(_:)`: a save panel | `exportDocument(_:)`: the share sheet |

## Rules that matter

1. Call `reloadData()` **immediately** after changing the data, before
   selecting, scrolling or returning to the run loop. Until then the table
   still asks about the old rows.
2. Row indexes in the API (selection, `clickedRow`, data source and delegate
   calls) are **data source indexes**, also while a filter hides rows. They are
   only valid until the next reload: keep record ids, not indexes, in menus and
   asynchronous work.
3. Give rows an **identity** (`rowIdentifierColumnID` or
   `tableView(_:identifierForRow:)`), unique per record.
4. The table holds its **data source and delegate weakly**; capture `self`
   weakly in `GHRowFilter.isIncluded`.
5. Keep `tableView(_:valueFor:row:)` a **cheap lookup**, and return static
   color constants for row tints and markers.
6. Don't put the table in an `NSScrollView` or a `UIScrollView`: it scrolls
   by itself.

## License

Gingham is free for any use, commercial too, with up to 10,000 rows a table
(a table with more shows the first 10,000 and a notice). A license key shows
every row: it's per developer and covers a major version (all of 1.x), and
apps shipped with it stay licensed. Register it at launch with
`GHLicense.register(_:)`.

| License | Price, per developer and major version | For |
| --- | --- | --- |
| Indie | $199 | A solo developer, or a company with less than $250,000 a year in revenue |
| Business | $599 | Any company |
| Enterprise | By agreement | Priority support and the source in escrow |

Open-source apps get a key for free.

- [Buy a license key](mailto:d.polikhranidi+gingham@gmail.com?subject=Gingham%20license%20key)
- [Get a 30-day trial key](mailto:d.polikhranidi+gingham@gmail.com?subject=Gingham%20trial%20key)

See [LICENSING.md](LICENSING.md) and [LICENSE](LICENSE);
`GHTableView.version` tells which version you have.

## Benchmarks

The same live data in Gingham and in Apple's tables, measured the same way
for each by an open benchmark, [Gingham Bench](https://github.com/digitalglobeby/gingham-bench)
(MIT): the code of every table, the data and [how it's measured](https://github.com/digitalglobeby/gingham-bench#how-its-measured).
Gingham's competitors are NSTableView as apps typically write it, NSTableView
tuned by hand (also in its cell-based mode), NSCollectionView and SwiftUI's
Table; the scenarios are live trades (20,000 rows), wide live trades (24
columns), an order book (200,000 rows with rows added and removed) and a
trade feed (1,000,000 rows). If you can make a competitor faster, open a pull
request there: it will be measured.

### The Mac, a large window (2040 × 1080 points)

Updates a second (max 120) · main thread busy (less leaves more room for
your app) · the Mac's power (the whole Mac's CPU and GPU, from
`powermetrics`; not the display or memory).

| Table | Live trades | Wide live trades | Order book | Trade feed |
| --- | --- | --- | --- | --- |
| **Gingham** | **120** · 32% · 1.35 W | **120** · 37% · 1.84 W | **120** · 36% · 1.82 W | **120** · 39% · 2.75 W |
| NSTableView | 28 · 95% · 3.68 W | 10 · 98% · 3.72 W | 10 · 99% · 3.80 W | 4 · 99% · 4.03 W |
| NSTableView, tuned | 53 · 92% · 3.76 W | 13 · 97% · 3.82 W | 33 · 98% · 4.03 W | 15 · 98% · 4.25 W |
| NSTableView, cell-based | 118 · 71% · 3.13 W | 48 · 96% · 3.82 W | 80 · 95% · 4.58 W | 45 · 98% · 4.81 W |
| NSCollectionView | 52 · 93% · 3.77 W | 13 · 97% · 3.84 W | 34 · 97% · 4.04 W | 15 · 96% · 4.24 W |
| SwiftUI Table | stuck | stuck | stuck | stuck |
| SwiftUI Table, tuned | 2 · 100% · 3.22 W | 1 · 100% · 3.26 W | stuck | stuck |
| SwiftUI Table, slots | 18 · 97% · 3.43 W | 5 · 99% · 3.37 W | 18 · 99% · 3.50 W | 4 · 99% · 3.24 W |

Gingham's figure is the frames it presented (its own count), the others'
the updates they applied: each the most frames with new data a table can
show (a screen capture of the window counts no more for any table).

The energy an update (the power over the updates a second) is lowest with
Gingham in all four: 15 mJ on the order book, against 57–392 mJ with the
AppKit tables.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, built-in display at 120 Hz
(2056 × 1329 points at 2×), Gingham 1.2.0, Release builds, medians of 3
runs, 2026-11-26 ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0255.md)).

### Where Gingham isn't ahead

From the same results ([the bench's full list](https://github.com/digitalglobeby/gingham-bench#where-gingham-isnt-ahead-and-what-it-doesnt-do)):

- In the default window the cell-based NSTableView also applies 120 updates
  a second in all four live scenarios, with its main thread busier (37–80%
  against 24–34%) and the Mac drawing more power (1.11–3.73 W against
  0.71–1.22 W).
- On a quiet table (5,000 rows, 10 changes a second) the tuned AppKit tables
  cost less: 2% of the main thread and 0.03–0.04 W, against Gingham's 5% and
  0.11 W.
- Scrolling 100,000 rows, the cell-based NSTableView's main thread is less
  busy (40% against 57%), while the Mac draws more power with it (1.31 W
  against 0.57 W).
- The Mac draws more power with Gingham in a 3840 × 2160-point table on
  the wide trades and the trade feed (4.62 and 7.27 W against 3.64–4.95 W
  with the AppKit tables, while Gingham shows 120 updates a second and they
  2–21), and on Binance's tickers than with the tuned NSTableView,
  NSCollectionView and the slot-based SwiftUI Table (0.41 W against
  0.33–0.37 W).
- Memory: Gingham's footprint is larger than the view-based tables' on the
  trades and the order book (94–145 MB against 62–113 MB in the default
  window, 525–587 MB against 153–499 MB at 3840 × 2160).
- The iPhone's well-written UIKit tables and SwiftUI's List keep up too,
  with their main thread busier.

The other results, in [Benchmarks](https://digitalglobeby.github.io/Gingham/documentation/gingham/benchmarks)
and the bench's README: the default window, a 3840 × 2160-point table, an
equal 30 updates a second, a 4K monitor, Binance's live tickers, sorting
1,000,000 rows by text and by number, and the iPhone (1,000,000 rows at 120
frames a second while scrolling, its main thread 26% busy, against 41% for
well-written UIKit tables).

## Documentation

The package has DocC documentation: a reference of its public types and
members, for the Mac and for the iPad and iPhone, and articles written for
the Mac. On the iPad and iPhone the table's API is the same, but for what is
the Mac's for now: `GHDataTable` (SwiftUI), the diffable data source, the
data source adapter, printing and PDF, and a few AppKit members such as
`tableColumn(withIdentifier:)` and `editColumn(_:row:with:select:)`. Drag and
drop and menus use UIKit's types (the table above maps the interactions).

| Article | Covers |
| --- | --- |
| Getting Started | Adding the package, columns, data source, showing and reloading |
| Integrating into an App | A complete CRM screen: model, data source, sorting, search, filters, menus, refresh, live updates, column sources for millions of rows, checklist |
| Migrating from NSTableView | The NSTableView → GHTableView mapping, the data source adapter, diffable data sources, what works differently |
| Defining Columns | Options, frozen columns, groups, icon columns, user customization, saving layouts |
| Editing Cells | Cell navigation, editing in place, check boxes and choices, Undo |
| Displaying Values | Value kinds, formats, tags, marks, sparklines, links, buttons, progress bars, ratings, pictures and videos, the pointer over cells |
| Summaries | Aggregates, value filters, formulas, scopes, group subtotals, large tables |
| Filtering and Search | Row filters, search matching, row indexes while filtering, empty states |
| Grouping Rows | Groups by column values, header rows with subtotals, collapsing, order of groups |
| Selection and Sorting | Selection API, row identity, sorting, re-sorting without reloading |
| Menus and Actions | Row context menus, actions, copying |
| Appearance | Sizes, row tints and markers, selection style, scrolling |
| Keyboard and Accessibility | Keyboard commands, type select, VoiceOver |
| Performance and Threading | What the table reads and when, large data, column sources, live updates, memory |
| Benchmarks | Gingham against Apple's tables on the Mac and the iPhone: what was measured, the results, the open bench |
| Using Gingham in SwiftUI | `GHDataTable`: columns, selection, sorting, editing, menus (the Mac's) |
| Licensing | The free limit, registering a key, what a key covers |
| Release Notes | What each version brought |

Read it at **https://digitalglobeby.github.io/Gingham/documentation/gingham**.
Symbol documentation also shows in Xcode's Quick Help (Option-click a symbol).

## Support

Bug reports, questions and ideas are welcome as issues. Gingham ships as a
binary; for a license key, write to **d.polikhranidi+gingham@gmail.com**.
