
// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "COFramework",

                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      
                      dependencies: [
                        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", from: "4.2.0")
                      ],
                      
                      targets: [.target(name: "COFramework",
                                        dependencies: ["ObjectMapper"],
                                        path: "COFramework/COFramework/Swift")],
                      
                      swiftLanguageVersions: [.v5]
)
