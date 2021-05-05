// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "vapor-nemid",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "VaporNemID",
            targets: ["VaporNemID"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/madsodgaard/sss-nemid.git", .branch("v1")),
    ],
    targets: [
        .target(
            name: "VaporNemID",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NemID", package: "sss-nemid"),
            ]
        ),
        .testTarget(
            name: "VaporNemIDTests",
            dependencies: [
                "VaporNemID",
                .product(name: "XCTVapor", package: "vapor"),
            ]
        ),
    ]
)
