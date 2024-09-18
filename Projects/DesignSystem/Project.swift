import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "DesignSystem",
    targets: [
        .make(
            target: .DesignCore,
            product: .framework,
            useResource: true,
            dependencies: [
                .external(.nuke)
            ]
        ),
        .makeUnitTest(
            target: .DesignCore,
            dependencies: [
                .target(name: .DesignCore)
            ]
        ),
        .make(
            target: .componentsKit,
            product: .framework,
            dependencies: [
                .target(name: .DesignCore)
            ]
        )
    ]
)
