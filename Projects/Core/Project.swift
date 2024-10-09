import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Core",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .configuration("Staging")),
        .release(name: .release)
    ]),
    targets: [
        .make(target: .coreKit),
        .make(target: .model),
        .make(
            target: .commonKit,
            dependencies: [
                .target(name: .coreKit),
                .target(name: .model)
            ]
        ),
        .make(
            target: .networkKit,
            dependencies: [
                .target(name: .commonKit),
                .external(.openapiGenerated)
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
