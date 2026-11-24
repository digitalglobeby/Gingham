// swift-tools-version: 6.2
// Gingham 1.1.3: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.3/Gingham.xcframework.zip",
            checksum: "de7ca9cdbfc0b74c51c802b9496b50ee7a851d12f0029b6535c81d30def46d57"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.1.3/GinghamICU.xcframework.zip",
            checksum: "7c822008e8bf822863d2dd4e16fe6ac3c65a6980464efc35952cb7e04604e967"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
