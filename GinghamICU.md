# GinghamICU

Collation keys from ICU, in an optional library of Gingham's package, in
the order of `localizedStandardCompare` (Finder's). Gingham makes its own
keys (`GHTextKeys`, the default) for European languages, Cyrillic, Greek and
the main scripts, and they are faster: a million texts in 0.17–0.21 s
against ICU's 0.38–0.40 s. Add this library for scripts Gingham doesn't key
yet (Thai), or texts where its keys leave many pairs to compare (Chinese
readings).

> [!IMPORTANT]
> **This adds about 9 MB to a Mac app and about 5 MB to an iPhone or iPad
> app** (ICU's code and its collation data). Use it when your tables sort
> many texts in scripts Gingham's own keys don't cover. Gingham doesn't
> depend on it, and apps that don't add it don't carry it.

It is safe for the Mac App Store: it brings its own ICU and calls nothing of
the system's, whose collation functions aren't public API. With Xcode's
default for apps (Strip Linked Product: All Symbols), none of ICU's function
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
text columns, and the order is the one comparing with
`localizedStandardCompare` gives.

## Why a separate library

It keeps Gingham free of ICU's size for everyone else. Its version is
Gingham's: both come in each release, and an app uses the two of the same
version.

## The ICU inside

It is ICU 76.1 (swift-foundation-icu's) with collation's data: every
collator (1,713: each one ICU has, with each collation type, and each one a
locale of Foundation's asks for) makes the same keys as with all of ICU's
data. An app that also uses swift-foundation-icu's `_FoundationICU` can have
both.

## Binary

`GinghamICU.xcframework` (macOS, iOS and the iOS simulator, arm64) goes with
the binary `Gingham.xcframework` of the same version. It exports only
GinghamICU's own symbols and calls nothing of the system's ICU.

## License

Like Gingham: free for any use with up to 10,000 rows a table, every row with a
license key (see [LICENSING.md](LICENSING.md) and [LICENSE](LICENSE)). The ICU
inside keeps its own licenses (Unicode, Apache 2.0): see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
