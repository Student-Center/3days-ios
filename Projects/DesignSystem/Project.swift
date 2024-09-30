import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "DesignSystem",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .configuration("Staging")),
        .release(name: .release)
    ]),
    targets: [
        .make(
            target: .designCore,
            product: .framework,
            useResource: true,
            dependencies: [
                .external(.nuke)
            ]
        ),
        .makeUnitTest(
            target: .designCore,
            dependencies: [
                .target(name: .designCore)
            ]
        )
    ]
)
