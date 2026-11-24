// swift-tools-version: 6.2
// Gingham 1.1.4: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.4/Gingham.xcframework.zip",
            checksum: "0bd32cec7eb560178dc08a72941a55968d99e824f074095e8e52d1aa18606fd7"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.4/GinghamICU.xcframework.zip",
            checksum: "0c1db1c7b93d5ec67077c98c12bb7a5eca298ffe733d2903cc8899ff67f319d8"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
