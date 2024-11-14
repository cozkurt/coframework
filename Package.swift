// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "COFramework",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
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
            publicHeadersPath: ".",
            exclude: ["Info.plist"]
        ),
        // Target for Swift files that depends on the Objective-C target
        .target(
            name: "COFramework",
            dependencies: ["COFrameworkObjC"],
            path: "COFramework/Swift",
            exclude: ["Info.plist"],
            linkerSettings: [
                .linkedFramework("CFNetwork", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS]))
            ]
        ),
        // Test target for COFramework
        .testTarget(
            name: "COFrameworkTests",
            dependencies: ["COFramework"],
            path: "COFramework/Tests",
            exclude: ["Info.plist", "Test Plans"],
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
