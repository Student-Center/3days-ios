import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Features",
    targets: [
        .make(
            target: .designPreview,
            dependencies: [
                .project(target: .coreKit)
            ]
        ),
        .make(
            target: .signUp,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .networkKit)
            ]
        ),
        .make(
            target: .main,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .networkKit)
            ]
        )
    ]
)
