// swift-tools-version: 6.2
// Gingham 1.2.0: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.2.0/Gingham.xcframework.zip",
            checksum: "79252575c0f7374e63d855598bb746ff928b3080556a1f518ef46656d846e5b7"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.2.0/GinghamICU.xcframework.zip",
            checksum: "7f57cc3d834888355506ac4e6a2201017ab0a1aceb4144fe241d37a1d9180aeb"
        ),
        // What `swift build` of this package builds (binary targets alone give
        // it nothing to build): code that imports both frameworks. In no product.
        .target(name: "GinghamBuildCheck", dependencies: ["Gingham", "GinghamICU"]),
    ]
)
