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
        .make(
            target: .networkKit,
            dependencies: [
                .project(target: .model),
                .target(name: .coreKit),
                .external(.swiftStomp)
            ]
        ),
        .make(
            target: .commonKit,
            dependencies: [
                .target(name: .networkKit)
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
