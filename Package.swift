// swift-tools-version: 6.0
// Gingham 1.0.2: binary frameworks for macOS 14, iOS and iPadOS 17 and later
// (Apple silicon). Free up to 10,000 rows a table; see LICENSING.md.

import PackageDescription

let package = Package(
    name: "Gingham",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "Gingham", targets: ["Gingham"]),
        // Optional: collation keys from a bundled ICU (about 9 MB a platform).
        .library(name: "GinghamICU", targets: ["GinghamICU", "Gingham"]),
    ],
    targets: [
        .binaryTarget(
            name: "Gingham",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.2/Gingham.xcframework.zip",
            checksum: "a705d8622f2b5537fb29c9f68269e53b741120c9b4441d70f170cc065785214d"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.2/GinghamICU.xcframework.zip",
            checksum: "317009d4d7ff7e9ac0cde6aa04ba05f48653e64cbb82aa44bb3cfdb7335ff1fc"
        ),
    ]
)
