// swift-tools-version: 6.2
// Gingham 1.1.2: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.2/Gingham.xcframework.zip",
            checksum: "2aed1ddfabff01fd3257c16858e39bd931fd95fa7500d5926f17918888d89490"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.2/GinghamICU.xcframework.zip",
            checksum: "b0939e396a3eb972fc44af113eb9ab1b7d32523be49aa24f9b6eb3b0d74fe76d"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
