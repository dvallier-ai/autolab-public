// swift-tools-version: 6.2
// Package manifest for the AutoLab macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "AutoLab",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "AutoLabIPC", targets: ["AutoLabIPC"]),
        .library(name: "AutoLabDiscovery", targets: ["AutoLabDiscovery"]),
        .executable(name: "AutoLab", targets: ["AutoLab"]),
        .executable(name: "autolab-mac", targets: ["AutoLabMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/AutoLabKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "AutoLabIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AutoLabDiscovery",
            dependencies: [
                .product(name: "AutoLabKit", package: "AutoLabKit"),
            ],
            path: "Sources/AutoLabDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "AutoLab",
            dependencies: [
                "AutoLabIPC",
                "AutoLabDiscovery",
                .product(name: "AutoLabKit", package: "AutoLabKit"),
                .product(name: "AutoLabChatUI", package: "AutoLabKit"),
                .product(name: "AutoLabProtocol", package: "AutoLabKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/AutoLab.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "AutoLabMacCLI",
            dependencies: [
                "AutoLabDiscovery",
                .product(name: "AutoLabKit", package: "AutoLabKit"),
                .product(name: "AutoLabProtocol", package: "AutoLabKit"),
            ],
            path: "Sources/AutoLabMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "AutoLabIPCTests",
            dependencies: [
                "AutoLabIPC",
                "AutoLab",
                "AutoLabDiscovery",
                .product(name: "AutoLabProtocol", package: "AutoLabKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
