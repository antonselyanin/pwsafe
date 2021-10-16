// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PwsafeSwift",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PwsafeSwift",
            targets: ["PwsafeSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.2.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PwsafeSwift",
            dependencies: []),
        .testTarget(
            name: "PwsafeSwiftTests",
            dependencies: ["PwsafeSwift", "Quick", "Nimble"],
            resources: [
                .copy("Resources/ECB_TBL.TXT"),
                .copy("Resources/test.psafe3")
            ]
        ),
    ]
)
