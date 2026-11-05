# Licensing

Gingham is free for any use, commercial too, with up to **10,000 rows** in a
table. A table with more rows shows the first 10,000 and a notice under them;
a **license key** shows them all. The license itself is [LICENSE](LICENSE).

## Free: up to 10,000 rows a table

No key, no sign-up, nothing to pay: use Gingham in a personal project, an app
you sell, a free app of a business or an internal tool, and ship it in your
app. Each table shows up to 10,000 rows of its data source (the rows the
data source has, before filters and searches). Everything else works the
same: sorting, filters, search, totals, copy and export work on the rows the
table shows.

When a table first comes near the limit (8,000 rows) and when it first keeps
to it, Gingham says so in the console (subsystem "Gingham", category
"License"), so you notice it while developing, not when a user's data grows.

## More rows: a license key

A license key removes the limit for the apps it is for:

- **Per developer.** Everyone who writes or debugs code that uses Gingham in
  the licensed apps needs a key; build machines and testers don't.
- **Per major version.** A key for 1.x works with 1.0, 1.1 and every other
  1.x release, for as long as you use them. Apps you ship with it stay
  licensed: you can keep selling and updating them without paying again. A
  later major version (2.x) needs a new key. `GHTableView.version` tells
  which version your app has.
- **Per app.** A key names its apps' bundle identifiers (or a prefix, such as
  `com.example.*`). It's checked on the device, without the network.

Register it once, at launch, before a table shows rows:

```swift
import Gingham

GHLicense.register("GH1.eyJidW5kbGVzIjpb…")
```

`GHLicense.status` tells what the key gives, and the console says why a key
doesn't fit (another app, another major version, an expired trial).

### Trying it with more rows

Ask for a trial key: it shows every row for 30 days.

### Open-source apps

If your app is open source as a whole (under a license the Open Source
Initiative approves) and published, write to us: open-source apps get a key
for free.

### Buying

Write to d.polikhranidi+gingham@gmail.com.

## GinghamICU

The optional GinghamICU library is licensed the same way. The ICU it is built
with isn't: it is ICU (the Unicode license) and code of swift-foundation-icu
(the Apache License 2.0), under their licenses (`THIRD-PARTY-NOTICES.md` in
the binary package, `Vendor/CollationICU/LICENSE.md` here).
