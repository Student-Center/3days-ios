// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [
            "Animation": .framework,
            "Animator": .framework,
            "AtomicTransition": .framework,
            "NavigationTransition": .framework,
            "NavigationTransitions": .framework,
            "RuntimeAssociation": .framework,
            "RuntimeSwizzling": .framework
        ],
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
        .package(
            url: "https://github.com/davdroman/swiftui-navigation-transitions.git",
            exact: "0.14.0"
        )
    ]
)
