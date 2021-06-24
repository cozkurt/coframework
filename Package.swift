
// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "COFramework",
                      
                      platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],

                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      
                      dependencies: [
                        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", from: "4.2.0")
                      ],
                      
                      targets: [.target(name: "COFramework",
                                        dependencies: ["ObjectMapper"],
                                        path: "COFramework/COFramework/Swift")],
                      
                      swiftLanguageVersions: [.v5]
)
