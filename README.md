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

**On a MacBook Pro (M1 Max, 120 Hz), Gingham shows a live order book of
200,000 rows with about 243,500 row changes a second, presenting 120 frames
a second with its main thread 36% busy while the Mac's CPU and GPU draw
1.8 W**; in the same 2040 × 1080-point table, the fastest NSTableView we
could write applies 80 updates a second and a typical one 10, their main
threads 95% and 99% busy and the Mac drawing 4.6 and 3.8 W.

https://github.com/user-attachments/assets/3a48cb81-c19a-44de-a020-48b649b5da5f

![Gingham, NSTableView, NSTableView in its cell-based mode and SwiftUI Table showing the same live order book](Assets/comparison.png)

The order book in Gingham, in NSTableView as apps typically write it, in
NSTableView's cell-based mode tuned by hand (the fastest AppKit table we
measured) and in SwiftUI's Table: 200,000 rows, about 243,500 row changes a
second, in a 2040 × 1080-point window. Four moments of a recording, each
window cut to the table's columns, its live numbers moved next to them and
its gray text lightened: the numbers were measured live meanwhile; the
tables below are the medians of quiet runs.

## Benchmarks

The same live data in Gingham and in Apple's tables, measured the same way
for each by an open benchmark, [Gingham Bench](https://github.com/digitalglobeby/gingham-bench)
(MIT): the code of every table, the data and [how it's measured](https://github.com/digitalglobeby/gingham-bench#how-its-measured).
Gingham is used through its public API (a data source, `sortsRows`, targeted
reloads). Its competitors on the Mac:

- **NSTableView** as apps typically write it: view-based, and the app sorts
  all the rows again after each batch of changes and reloads the rows in
  view.
- **NSTableView, tuned** as an AppKit expert would: changed cells updated in
  place, numbers formatted by hand, an incremental sort.
- **NSTableView, cell-based**: its older cell-based mode, tuned the same way.
- **NSCollectionView**, tuned the same way.
- **SwiftUI Table**, as documented, tuned, and with its rows identified by
  their place ("slots"), as the tuned AppKit tables do.

The scenarios: **live trades** (20,000 rows sorted by amount, about 44,800
row changes a second), **wide live trades** (the same with 24 columns, 13 of
them in view in the default window), an **order book** (200,000 rows, about
243,500 row changes a second with rows added and removed) and a **trade
feed** (1,000,000 rows, about 300,000 row changes a second); and, where
every table should keep up, a **quiet table** (5,000 rows, 10 changes a
second) and **scrolling** 100,000 rows. If you can make a competitor faster,
open a pull request there: it will be measured.

The tables below were measured in one night, 2026-11-26, with Gingham 1.2.0
(the 4K monitor's on 2026-11-24, with Gingham 1.1.3). Each cell gives how
many updates a second the table showed or applied (its note says which) ·
how busy its main thread was (less leaves more room for your app) · **the
Mac's power**: what the whole Mac's CPU and GPU drew while the run measured,
from `powermetrics` (every process, the window server's compositing
included; not the display or memory). The power counts all of a table's
work: on the main thread, on other threads and on the GPU.

### Mac: the default window (1000 × 640 points)

Frames with new data a second (max 120) · main thread busy · the Mac's
power.

| Table | Live trades | Wide live trades | Order book | Trade feed |
| --- | --- | --- | --- | --- |
| **Gingham** | **74** · 27% · 0.71 W | **75** · 32% · 0.78 W | **111** · 34% · 1.04 W | **111** · 24% · 1.22 W |
| NSTableView | 43 · 96% · 3.73 W | 22 · 95% · 3.57 W | 19 · 99% · 3.84 W | 10 · 99% · 4.01 W |
| NSTableView, tuned | 56 · 64% · 2.62 W | 36 · 89% · 3.47 W | 55 · 98% · 4.17 W | 42 · 98% · 4.10 W |
| NSTableView, cell-based | 69 · 37% · 1.11 W | 62 · 47% · 1.66 W | 90 · 80% · 3.58 W | 95 · 78% · 3.73 W |
| NSCollectionView | 56 · 64% · 2.67 W | 42 · 83% · 3.34 W | 55 · 98% · 4.17 W | 72 · 97% · 4.31 W |
| SwiftUI Table | 0 · 100% · 3.73 W | 0 · 100% · 3.69 W | stuck | stuck |
| SwiftUI Table, tuned | 4 · 100% · 3.23 W | 1 · 100% · 3.23 W | stuck | stuck |
| SwiftUI Table, slots | 27 · 96% · 3.45 W | 8 · 98% · 3.32 W | 28 · 97% · 3.52 W | 5 · 99% · 3.23 W |

Frames with new data: how many times a second the table's picture actually
changed, counted from the screen in one more run; like frames a second, but
a frozen table scores 0. The screen capture counts up to about 110 a second;
Gingham presented 120 frames a second in all four. Live trades are sorted by
amount, and not every batch of changes reaches the rows in view, so no table
gets near 120 there. Gingham and the cell-based NSTableView applied new
changes at every refresh, the cell-based table with its main thread busier
and the Mac drawing more power. "Stuck": the main thread didn't come back
within 15 s after the measured window.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, built-in display at 120 Hz
(2056 × 1329 points at 2×), Gingham 1.2.0, Release builds, medians of 3
runs, 2026-11-26 ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0025.md)).

### Mac: a large window (2040 × 1080 points)

Frames presented a second by Gingham, updates applied a second by the others
(max 120) · main thread busy · the Mac's power.

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

As above, the screen capture can't count above about 110 a second, so the
table gives, for Gingham, the frames it presented (its own count) and, for
the others, the updates they applied. Both are the most frames with new data
a table can have shown: a frame presented may show no new data, and an
update applied may not reach the screen. The screen capture's counts, no
higher than these for any table (the order book: Gingham 112, the cell-based
NSTableView 76), are in the results.

The energy an update (the power over the updates a second) is lowest with
Gingham in all four: 15 mJ on the order book, against 57–392 mJ with the
AppKit tables.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, built-in display at 120 Hz
(2056 × 1329 points at 2×), Gingham 1.2.0, Release builds, medians of 3
runs, 2026-11-26 ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0255.md)).

### Mac: a 3840 × 2160-point table at 120 Hz

A window of 3840 × 2160 points on the MacBook's display at 2×, a table of
7680 × 4320 pixels, of which about a third (2056 × 1290 points) is on the
screen. Frames presented a second by Gingham, updates applied a second by
the others (max 120) · main thread busy · the Mac's power.

| Table | Live trades | Wide live trades | Order book | Trade feed |
| --- | --- | --- | --- | --- |
| **Gingham** | **120** · 37% · 3.21 W | **120** · 47% · 4.62 W | **120** · 38% · 3.84 W | **120** · 61% · 7.27 W |
| NSTableView | 14 · 97% · 3.62 W | 5 · 99% · 3.64 W | 4 · 100% · 3.75 W | 2 · 100% · 4.01 W |
| NSTableView, tuned | 20 · 96% · 3.68 W | 6 · 99% · 3.66 W | 16 · 97% · 3.85 W | 7 · 99% · 4.13 W |
| NSTableView, cell-based | 42 · 98% · 4.56 W | 18 · 99% · 4.09 W | 38 · 99% · 5.31 W | 21 · 99% · 4.95 W |
| NSCollectionView | 20 · 96% · 3.75 W | 6 · 99% · 3.68 W | 16 · 96% · 3.83 W | 7 · 99% · 4.16 W |
| SwiftUI Table | stuck | stuck | stuck | stuck |
| SwiftUI Table, tuned | 1 · 100% · 3.22 W | 0 · 100% · 3.22 W | stuck | stuck |
| SwiftUI Table, slots | 9 · 98% · 3.33 W | 3 · 100% · 3.34 W | 9 · 98% · 3.38 W | 2 · 100% · 3.28 W |

At this size the screen capture costs too much to run alongside: with it,
Gingham's rate fell to 60–71 a second (the results' first column). The runs
above went without it, so nothing outside the table counted Gingham's 120.
Presenting 120 frames a second of so large a table, the Mac draws more
power with Gingham than with the AppKit tables on the wide trades and the
trade feed (4.62 and 7.27 W, against 3.64–4.95 W), where they apply 2–21
updates a second; an update takes 38 and 61 mJ with Gingham, 233–2,109 mJ
with them.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, built-in display at 120 Hz
(2056 × 1329 points at 2×), Gingham 1.2.0, Release builds, medians of 3
runs, 2026-11-26 ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0356.md)).

### Mac: an equal 30 updates a second

An app whose table can't keep up with every refresh updates it 30 or 60
times a second instead. Here every table gets the changes in one batch 30
times a second, so the tables that hold the rate compare by what it costs
them. 2040 × 1080 points: updates a second (max 30) · main thread busy · the
Mac's power.

| Table | Live trades | Wide live trades | Order book | Trade feed |
| --- | --- | --- | --- | --- |
| **Gingham** | **30** · 22% · 0.44 W | **30** · 24% · 0.62 W | **30** · 24% · 0.76 W | **30** · 21% · 0.96 W |
| NSTableView | 28 · 95% · 3.65 W | 10 · 98% · 3.68 W | 10 · 99% · 3.82 W | 4 · 99% · 4.04 W |
| NSTableView, tuned | 30 · 63% · 2.54 W | 13 · 98% · 3.82 W | 30 · 89% · 3.70 W | 15 · 98% · 4.25 W |
| NSTableView, cell-based | 30 · 35% · 1.16 W | 30 · 71% · 2.79 W | 30 · 42% · 1.80 W | 30 · 67% · 3.40 W |
| NSCollectionView | 30 · 63% · 2.56 W | 14 · 97% · 3.84 W | 30 · 87% · 3.67 W | 15 · 96% · 4.22 W |
| SwiftUI Table | stuck | stuck | stuck | stuck |
| SwiftUI Table, tuned | 2 · 100% · 3.22 W | 1 · 100% · 3.24 W | stuck | stuck |
| SwiftUI Table, slots | 18 · 97% · 3.43 W | 6 · 99% · 3.36 W | 18 · 98% · 3.50 W | 4 · 99% · 3.28 W |

Where a table held 30 updates a second, in this window and in the default
one, the Mac drew 0.24–0.96 W with Gingham and 0.53–3.70 W with the others;
the cell-based NSTableView held the rate in every scenario, at 0.53–3.40 W.
At 60 updates a second (2040 × 1080) Gingham held it in all four at
0.74–1.54 W, the cell-based NSTableView on the live trades and the order
book at 2.12 and 3.47 W, and no other table in any.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, built-in display at 120 Hz
(2056 × 1329 points at 2×), Gingham 1.2.0, Release builds, medians of 3
runs, 2026-11-26 ([30 a second](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0529.md),
[in the default window](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0450.md),
[60 a second](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0608.md)).

### Mac: a 4K monitor at 60 Hz (3840 × 2160 points)

An LG UltraFine 4K at 60 Hz (3840 × 2160 points at 1×; 3840 × 2130 points of
the window on it). Frames presented a second by Gingham, updates applied a
second by the others (max 60) · main thread busy.

| Table | Live trades | Wide live trades | Order book | Trade feed |
| --- | --- | --- | --- | --- |
| **Gingham** | **60** · 28% | **60** · 33% | **60** · 32% | **60** · 45% |
| NSTableView | 14 · 93% | 5 · 98% | 4 · 99% | 2 · 99% |
| NSTableView, tuned | 18 · 93% | 6 · 98% | 16 · 96% | 6 · 98% |
| NSTableView, cell-based | 56 · 95% | 19 · 98% | 48 · 98% | 20 · 97% |
| NSCollectionView | 19 · 93% | 6 · 98% | 16 · 94% | 7 · 97% |
| SwiftUI Table | stuck | stuck | stuck | stuck |
| SwiftUI Table, tuned | 1 · 100% | 0 · 100% | stuck | 0 · 100% |

Counted from the screen, Gingham's frames with new data were 57–58 a second
(max 60). In a 3700 × 1890 window, which fits the screen, Gingham presented
60 frames a second at 28–42% busy and the cell-based NSTableView applied
22–59 updates a second ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-24-1258.md)).

An earlier measurement: MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, LG
UltraFine 4K at 60 Hz, Gingham 1.1.3, Release builds, medians of 3 runs,
2026-11-24, before the bench's tuned AppKit tables formatted numbers by hand
and the cell-based one kept its text, and without the Mac's power
([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-24-1345.md);
the cell-based NSTableView's live trades, whose three runs there were
invalid, [measured again](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-24-1648.md)).

### Mac: Binance's live tickers

On Binance's live tickers (about 3,100 pairs, a live market, so the numbers
vary), Gingham keeps up with its main thread 14% busy, the tuned
NSTableView, NSCollectionView and the slot-based SwiftUI Table 20–22%, the
cell-based NSTableView 29% and the typical NSTableView 83% (default window,
[results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0025.md#binance-tickers)).

### Mac: sorting 1,000,000 rows

A header click on a table of 1,000,000 rows, sorted in Finder's order
(`localizedStandardCompare`): by pair (about 500 distinct texts) or by
account (nearly every row a different text), first in a fresh process, then
by the other column, then by the first column again. Time until the sorted
order is on the screen; Gingham is the fastest in every one, though the
first sort by pair is close (0.07 s, the cell-based NSTableView 0.09 s).

| Table | Pair | Then account | Pair again | Account | Then pair | Account again |
| --- | --- | --- | --- | --- | --- | --- |
| **Gingham** | **0.07 s** | **0.13 s** | **0.01 s** | **0.19 s** | **0.04 s** | **0.02 s** |
| NSTableView | 5.22 s | 7.97 s | 5.15 s | 8.00 s | 5.22 s | 7.97 s |
| NSTableView, tuned | 0.17 s | 7.88 s | 0.12 s | 7.94 s | 0.17 s | 0.16 s |
| NSTableView, cell-based | 0.09 s | 7.79 s | 0.05 s | 7.82 s | 0.08 s | 0.07 s |
| NSCollectionView | 0.12 s | 7.85 s | 0.04 s | 7.86 s | 0.12 s | 0.06 s |
| SwiftUI Table | not sorted within 60 s | | | not sorted within 60 s | | |
| SwiftUI Table, tuned | 0.94 s | 13.43 s | 0.88 s | 13.46 s | 0.92 s | 0.91 s |
| SwiftUI Table, slots | 1.19 s | 13.94 s | 1.13 s | 13.80 s | 1.15 s | 1.36 s |

By amount, a number (then by price, then by amount again): Gingham 0.04,
0.04 and 0.03 s, the tuned AppKit tables 0.07–0.16 s, the typical
NSTableView 0.22–0.29 s. The tuned AppKit tables sort in the background and
keep the keys of the columns they sorted; the typical NSTableView sorts on
the main thread, and the app stops for the whole sort.

MacBook Pro (M1 Max, 32 GB), macOS 27.2.1, Gingham 1.2.0, Release builds,
medians of 3 runs, 2026-11-26 ([results](https://github.com/digitalglobeby/gingham-bench/blob/main/results/2026-11-26-0025.md#sort-by-pair)).

### iPhone: scrolling while values change

UITableView and UICollectionView as typically written (changed rows
reconfigured, as Apple recommends) and tuned (changed values set on the cells
in view), and SwiftUI's List, with 100,000 rows and 1,000 changes a second.
What the render server showed: Instruments' Animation Hitches during the
app's scroll tests (steady, fast and flicks, one run each) and XCUITest's
real flicks (UIKit's own scroll metric, the median of five flicks).

| Table | Animation Hitches: hitch time a second | Real flicks (Gingham 1.1.1): frames a second · hitches |
| --- | --- | --- |
| **Gingham** | 0–6.2 ms | 117.6 · 0 |
| UITableView | 501–506 ms | 111.1 · 294 (72.5 ms a second) |
| UITableView, tuned | 1.0–6.2 ms | 119.0 · 0 |
| UICollectionView | 0–2.1 ms | 116.0 · 0 |
| UICollectionView, tuned | 2.1 ms | 118.7 · 0 |
| SwiftUI List | 1.6–4.2 ms | 117.3 · 0 |

The app's own meter (its main thread's frame callbacks, which don't see the
render server's work), scrolling a flick a second, four down and four up,
while values change (the bench's `flicks` test, median of 3 runs): frames a
second · main thread busy.

| Table | 100,000 rows, 1,000 changes/s | 1,000,000 rows, 10,000 changes/s |
| --- | --- | --- |
| **Gingham** | 120 · **19%** | 120 · **29%** |
| UITableView | 62.4 · 80% | 7 · 99% |
| UITableView, tuned | 120 · 40% | 120 · 41% |
| UICollectionView | 120 · 43% | 120 · 41% |
| UICollectionView, tuned | 120 · 39% | 120 · 41% |
| SwiftUI List | 120 · 40% | 120 · 41% |

On the iPhone, well-written UIKit tables and SwiftUI's List keep up too;
Gingham does it with its main thread less busy (19% and 29%, to their
39–43%), and the typical UITableView falls behind, to 7 frames a second
with a million rows on the app's meter. SwiftUI's Table shows only its
first column on the iPhone and isn't compared there.

iPhone 15 Pro Max, iOS 27.2.1, 120 Hz, Gingham 1.1.3, Release build, medians
of 3 runs, 2026-11-24; the real flicks: Gingham 1.1.1, 2026-11-23
([results](https://github.com/digitalglobeby/gingham-bench/tree/main/results/ios)).

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
- The Mac draws more power with Gingham in the 3840 × 2160-point table on
  the wide trades and the trade feed (above), and on Binance's tickers than
  with the tuned NSTableView, NSCollectionView and the slot-based SwiftUI
  Table (0.41 W against 0.33–0.37 W).
- Memory: Gingham's footprint is larger than the view-based tables' on the
  trades and the order book (94–145 MB against 62–113 MB in the default
  window, 525–587 MB against 153–499 MB at 3840 × 2160).
- The iPhone's well-written UIKit tables and SwiftUI's List keep up too
  (above).

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

- [Buy a license key](mailto:d.polikhranidi+gingham@gmail.com?subject=Gingham%20license%20key)
- [Get a 30-day trial key](mailto:d.polikhranidi+gingham@gmail.com?subject=Gingham%20trial%20key)

See [LICENSING.md](LICENSING.md) and [LICENSE](LICENSE);
`GHTableView.version` tells which version you have.

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
