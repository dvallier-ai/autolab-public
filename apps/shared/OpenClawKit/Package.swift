// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AutoLabKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "AutoLabProtocol", targets: ["AutoLabProtocol"]),
        .library(name: "AutoLabKit", targets: ["AutoLabKit"]),
        .library(name: "AutoLabChatUI", targets: ["AutoLabChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "AutoLabProtocol",
            path: "Sources/AutoLabProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AutoLabKit",
            dependencies: [
                "AutoLabProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/AutoLabKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AutoLabChatUI",
            dependencies: [
                "AutoLabKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/AutoLabChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "AutoLabKitTests",
            dependencies: ["AutoLabKit", "AutoLabChatUI"],
            path: "Tests/AutoLabKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
