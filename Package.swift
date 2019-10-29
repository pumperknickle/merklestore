// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Merklestore",
    products: [
        .library(name: "Merklestore", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),
        .package(url: "https://github.com/vapor/redis.git", from: "3.4.0"),
        .package(url: "https://github.com/pumperknickle/Bedrock.git", from: "0.0.5"),
        .package(url: "https://github.com/pumperknickle/CryptoStarterPack.git", from: "1.0.9"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Redis", "Vapor", "Bedrock", "CryptoStarterPack"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
