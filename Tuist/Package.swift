// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:],
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug),
                .release(name: .configuration("Staging")),
                .release(name: .release)
            ]
        )
    )
#endif

let package = Package(
    name: "three-days-iOS",
    dependencies: [
        .package(path: "../OpenApiGenerator"),
        .package(
            url: "https://github.com/kean/Nuke.git",
            exact: "12.8.0"
        ),
    ]
)
