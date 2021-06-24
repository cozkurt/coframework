
// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "COFramework",
                      platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],
                      
                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      
                      dependencies: [
                        // Dependencies declare other packages that this package depends on.
                        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", .upToNextMajor(from: "4.2.0"))
                      ],
                      
                      targets: [.target(name: "COFramework",
                                        dependencies: [
                                          .product(name: "ObjectMapper", package: "ObjectMapper")
                                        ],
                                        path: "COFramework/COFramework/Swift")],
                      
                      swiftLanguageVersions: [.v5]
)

