# GinghamICU

Collation keys from an ICU built into the app, in an optional library of
Gingham's package, in exactly the order of `localizedStandardCompare`
(Finder's). Since 1.5.0 Gingham makes its own keys (`GHTextKeys`, the
default) for European languages, Cyrillic, Greek and the main scripts, and
they are faster: a million texts in 0.17–0.21 s against ICU's 0.38–0.40 s.
Add this library for scripts Gingham doesn't key yet, or texts where its keys
leave many pairs to compare (Chinese readings).

> [!IMPORTANT]
> **This adds about 8.7 MB per architecture to your app** (ICU's code and its
> collation data): about 17 MB in a universal (Intel + Apple silicon) app,
> which the Mac App Store doesn't thin. From source it also adds about 30
> seconds to a clean build. Use it when your tables sort many texts in
> scripts Gingham's own keys don't cover. Gingham doesn't depend on it, and
> apps that don't add it don't build it.

It is safe for the Mac App Store: the ICU is linked into the app
(swift-foundation-icu's) and imports nothing from the
system's ICU, whose collation functions aren't public API. With Xcode's
default for apps (Strip Linked Product: All Symbols), none of its function
names stay in the app either.

## Use

Add the library to your app's target, next to Gingham:

```swift
.target(name: "MyApp", dependencies: [
    .product(name: "Gingham", package: "Gingham"),
    .product(name: "GinghamICU", package: "Gingham"),
]),
```

Then at launch:

```swift
import Gingham
import GinghamICU

GHTableView.defaultCollationKeyProvider = GHBundledICUCollation()   // tables made from now on
// or for one table:
table.collationKeyProvider = GHBundledICUCollation()
```

That's all: tables that sort rows themselves (`sortsRows`) use the keys for
text columns. Rows whose keys are equal are compared, and every pair of
neighbors is checked with `localizedStandardCompare`, so the order never
differs from comparing (keys that disagree make the table sort by comparing).

## Why a separate library

It keeps Gingham free of the ICU's size and build time for everyone else.
Its version is Gingham's: GinghamICU 1.3 goes with Gingham 1.3.

## The ICU inside

It is swift-foundation-icu's ICU 76.1 with only the data collation reads:
the collation tree and two small files for language tags' extensions, 4.3 MB
of ICU's 34 MB. Every collator (1,713: each one ICU has, with each collation
type, and each one a locale of Foundation's asks for) makes the same keys as
with all the data. Its module is private to the framework, so an app with
swift-foundation-icu's `_FoundationICU` can have both.

## Binary

`GinghamICU.xcframework` (macOS, iOS and the iOS simulator, arm64) links the
binary `Gingham.xcframework` and has the ICU linked inside: it exports only
GinghamICU's own symbols and imports nothing from the system's ICU.

## License

Like Gingham: free for any use with up to 10,000 rows a table, every row with a
license key (see [LICENSING.md](LICENSING.md) and [LICENSE](LICENSE)). The ICU
inside keeps its own licenses (Unicode, Apache 2.0): see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
