import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Core",
    targets: [
        .make(target: .coreKit),
        .make(
            target: .networkKit,
            dependencies: [
                .external(externalDependency: .alamofire)
            ]
        ),
        .makeUnitTest(
            target: .coreKit,
            dependencies: [
                .target(name: .coreKit)
            ]
        )
    ]
)
