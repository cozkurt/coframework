// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "COFramework",
    products: [
        .library(
            name: "COFramework",
            targets: ["COFramework"]
        )
    ],
    targets: [
        // Target for Objective-C files
        .target(
            name: "COFrameworkObjC",
            path: "COFramework/ObjC",
            publicHeadersPath: "."
        ),
        // Target for Swift files that depends on the Objective-C target
        .target(
            name: "COFramework",
            dependencies: ["COFrameworkObjC"],
            path: "COFramework/Swift"
        )
    ]
)
