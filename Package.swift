// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONValue",
    products: [
        .library(
            name: "JSONValue",
            targets: ["JSONValue"]),
    ],
    targets: [
        .target(
            name: "JSONValue"),
        .testTarget(
            name: "JSONValueTests",
            dependencies: ["JSONValue"]
        ),
    ]
)
