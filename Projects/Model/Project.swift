import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Model",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .configuration("Staging")),
        .release(name: .release)
    ]),
    targets: [
        .make(
            target: .model,
            dependencies: [
                .project(target: .coreKit),
                .external(.openapiGenerated)
            ]
        )
    ]
)
