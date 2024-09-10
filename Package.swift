// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BudCommon",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BudCommon",
            targets: ["BudCommon", "Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.13.1"),
        .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", exact: "6.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.0.0"),
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.1.2"),
        .package(url: "https://github.com/scalessec/Toast-Swift.git", exact: "5.1.1"),
        .package(url: "https://github.com/relatedcode/ProgressHUD.git", exact: "14.1.3"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", exact: "1.8.3"),
        .package(url: "https://github.com/TakeScoop/SwiftyRSA.git", exact: "1.8.0"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", exact: "3.7.9"),
        .package(url: "https://github.com/wxxsw/SwiftTheme.git", exact: "0.6.4"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.0.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "7.12.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "3.7.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BudCommon", dependencies: [
                .tac,
                .swifter,
                .logging,
                .promise,
                .moya,
                .toast,
                .hud,
                .crypto,
                .rsa,
                .refresh,
                .theme,
                .snap,
                .fisher,
                .phone]),
        .binaryTarget(name: "Kit", path: "Kit.xcframework"),
        .testTarget(
            name: "BudCommonTests",
            dependencies: [
                "BudCommon",
                .tac,
                .swifter,
                .logging,
                .promise,
                .moya,
                .toast,
                .hud,
                .crypto,
                .rsa,
                .refresh,
                .theme,
                .snap,
                .fisher,
                .phone,
            ]),
    ])

extension Target.Dependency {
    static let tac = Self.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let swifter = Self.product(name: "SwifterSwift", package: "SwifterSwift")
    static let logging = Self.product(name: "Logging", package: "swift-log")
    static let promise = Self.product(name: "PromiseKit", package: "PromiseKit")
    static let moya = Self.product(name: "Moya", package: "Moya")
    static let toast = Self.product(name: "Toast", package: "Toast-Swift")
    static let hud = Self.product(name: "ProgressHUD", package: "ProgressHUD")
    static let crypto = Self.product(name: "CryptoSwift", package: "CryptoSwift")
    static let rsa = Self.product(name: "SwiftyRSA", package: "SwiftyRSA")
    static let refresh = Self.product(name: "MJRefresh", package: "MJRefresh")
    static let theme = Self.product(name: "SwiftTheme", package: "SwiftTheme")
    static let snap = Self.product(name: "SnapKit", package: "SnapKit")
    static let fisher = Self.product(name: "Kingfisher", package: "Kingfisher")
    static let phone = Self.product(name: "PhoneNumberKit", package: "PhoneNumberKit")
}
