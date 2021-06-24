
// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "COFramework",
                      platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],
                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      targets: [.target(name: "COFramework", path: "COFramework/COFramework", dependencies: ["ObjectMapper"]) ])
