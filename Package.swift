// swift-tools-version: 6.0
// Gingham 1.0.1: binary frameworks for macOS 14, iOS and iPadOS 17 and later
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
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.1/Gingham.xcframework.zip",
            checksum: "3965d1d9539649e1a2f09e123208780ac09e1c55f2fb3d6c4304ef76b7f67967"
        ),
        .binaryTarget(
            name: "GinghamICU",
            url: "https://github.com/digitalglobeby/Gingham/releases/download/1.0.1/GinghamICU.xcframework.zip",
            checksum: "98a1462804bd785ce320fef4d432efb61fbc281ab14a13623a08b232cde92505"
        ),
    ]
)
