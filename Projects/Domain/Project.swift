import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Domain",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .configuration("Staging")),
        .release(name: .release)
    ]),
    targets: [
        .make(
            target: .commonDomain,
            dependencies: [
                .external(.openapiGenerated),
                .project(target: .model)
            ]
        ),
        .make(
            target: .signUpDomain,
            dependencies: [
                .external(.openapiGenerated),
                .project(target: .model)
            ]
        )
    ]
)
