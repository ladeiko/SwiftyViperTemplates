// swift-tools-version: 5.10
import PackageDescription

// Pure-SwiftUI VIPER demo. NOTE: deliberately has NO dependency on
// ViperMcFlurryX / UIKit — SwiftUI owns view lifetime and navigation.
// The reusable runtime comes from the published ViperSwiftUI package.
let package = Package(
    name: "SwiftUINativeViperDemo",
    platforms: [.macOS(.v14), .iOS(.v16)],
    products: [
        .library(name: "SwiftUINativeViper", targets: ["SwiftUINativeViper"]),
        .executable(name: "DemoApp", targets: ["DemoApp"]),
    ],
    dependencies: [
        // SSH URL because the repo is currently private; switch to the https
        // URL once it is public. Package identity ("swiftui-viper") is the same.
        .package(url: "git@github.com:ladeiko/swiftui-viper.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUINativeViper",
            dependencies: [
                .product(name: "ViperSwiftUI", package: "swiftui-viper"),
            ],
            path: "example/SwiftUINativeViper"
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["SwiftUINativeViper"],
            path: "example/DemoApp"
        ),
        .testTarget(
            name: "SwiftUINativeViperTests",
            dependencies: [
                "SwiftUINativeViper",
                .product(name: "ViperSwiftUI", package: "swiftui-viper"),
            ],
            path: "example/Tests"
        ),
    ]
)
