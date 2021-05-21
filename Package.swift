
// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "COFramework",
                      platforms: [.iOS(.v10)],
                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      targets: [.target(name: "COFramework", path: "COFramework")],
                      swiftLanguageVersions: [.v5])
