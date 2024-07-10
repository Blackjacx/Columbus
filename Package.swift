// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Columbus",
    defaultLocalization: "en",
    platforms: [
        // .macOS(.v10_12),
        .iOS(.v14),
        .tvOS(.v12)
        // .watchOS(.v3)
    ],
    products: [
        .library(name: "Columbus", targets: ["Columbus"])
    ],
    targets: [
        .target(
            name: "Columbus",
            resources: [.process("Resources/Countries.json")]
        ),
        .testTarget(name: "ColumbusTests", dependencies: ["Columbus"])
    ],
    swiftLanguageVersions: [.v5]
)
