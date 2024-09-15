import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "DesignSystem",
    targets: [
        .make(
            target: .DesignCore,
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
            dependencies: [
                .target(name: .DesignCore)
            ]
        )
    ]
)
