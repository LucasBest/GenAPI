// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GenAPI",
    platforms: [
        .iOS(.v10), .tvOS(.v10), .watchOS(.v2),
    ], products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GenAPI",
            targets: ["GenAPI"]),
    ],
    targets: [
        .target(
            name: "GenAPI",
            path: "GenAPI/Classes/"),
        .testTarget(
            name: "GenAPITests",
            dependencies: ["GenAPI"],
            path: "Example/Tests/"),
    ]
)
