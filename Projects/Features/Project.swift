import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Features",
    targets: [
        .make(
            target: .main,
            dependencies: [
                .project(target: .coreKit),
                .project(target: .networkKit),
                .project(target: .componentsKit)
            ]
        )
    ]
)
