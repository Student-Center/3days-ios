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
            target: .searchCompany,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore)
            ]
        ),
        .makeUnitTest(
            target: .searchCompany,
            dependencies: [
                .project(target: .searchCompany)
            ]
        ),
        .make(
            target: .signUp,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore),
                .project(target: .searchCompany)
            ]
        ),
        .makeUnitTest(
            target: .signUp,
            dependencies: [
                .project(target: .signUp)
            ]
        ),
        .make(
            target: .home,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore),
                .project(target: .searchCompany)
            ]
        ),
        .makeUnitTest(
            target: .home,
            dependencies: [
                .project(target: .home)
            ]
        ),
        .make(
            target: .chat,
            dependencies: [
                .project(target: .commonKit),
                .project(target: .designCore)
            ]
        )
    ]
)
