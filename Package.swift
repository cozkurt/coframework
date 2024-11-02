
// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "COFramework",
                      platforms: [.iOS(.v13)],

                      products: [
                        .library(name: "COFramework",
                                 targets: ["COFramework"])],
                      
                      targets: [
                        .target(name: "COFramework",
                                dependencies: [],
                                path: "COFramework")
                      ]
                      swiftLanguageVersions: [.v5]
)
