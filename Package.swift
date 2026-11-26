// swift-tools-version: 6.2
// Gingham 1.2.1: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
        // Optional: collation keys from a bundled ICU (about 9 MB in a Mac app, 5 MB in an iOS app).
        .library(name: "GinghamICU", targets: ["GinghamICU", "Gingham"]),
    ],
    targets: [
        .binaryTarget(
            name: "Gingham",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.2.1/Gingham.xcframework.zip",
            checksum: "d1cc1925895dfe33f2f09d00848fcdb1dd57a03e5c680e54a7ff1c213004b98c"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.2.1/GinghamICU.xcframework.zip",
            checksum: "5bdf4f0f60e8f6b05179b0056c96a54a0ca546b32f9f8a7e30c0f462cfe91557"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
