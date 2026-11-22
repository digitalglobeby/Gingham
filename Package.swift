// swift-tools-version: 6.2
// Gingham 1.1.1: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.1/Gingham.xcframework.zip",
            checksum: "cb4f0b9ee9b5a417ec4ebc3093a89b27793811ff4a444d50e09932a076cefd8c"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.1/GinghamICU.xcframework.zip",
            checksum: "814abd65881fbad4b9d7598268ed55d6d0ea7d109a537c1946d05097a0d1bb99"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
