import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Features",
    targets: [
        .make(
            target: .designPreview,
            dependencies: [
                .project(target: .coreKit),
                .project(target: .designCore)
            ]
        ),
        .make(
            target: .signUp,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore),
                .project(target: .networkKit)
            ]
        ),
        .makeUnitTest(
            target: .signUp,
            dependencies: [
                .project(target: .signUp)
            ]
        ),
        .make(
            target: .main,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore),
                .project(target: .networkKit)
            ]
        )
    ]
)
