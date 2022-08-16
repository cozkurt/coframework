
// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "COFramework",
                      
                      platforms: [.iOS(.v13)],

                      products: [.library(name: "COFramework", targets: ["COFramework"])],
                      
                      dependencies: [
                        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", from: "4.2.0"),
                        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.6.2")
                      ],
                      
                      targets: [
                        .target(name: "COFramework", dependencies: ["ObjectMapper"], path: "COFramework/COFramework/Swift"),
                        .target(name: "COFramework", dependencies: ["Alamofire"], path: "COFramework/COFramework/Swift")
                      ]
)
