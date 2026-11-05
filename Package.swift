// swift-tools-version: 6.0
// Gingham 1.0.0: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.0/Gingham.xcframework.zip",
            checksum: "50e025785faef4233db7538a995f04f065afbb51a5d9350194dd605a913efdaf"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.0/GinghamICU.xcframework.zip",
            checksum: "06c22a1a6f915f99f465334bd2a37e5d0ae0e1d9deb1f252fe03012668009314"
        ),
    ]
)
