import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .make(
    name: "Core",
    targets: [
        .make(target: .coreKit),
        .make(target: .model),
        .make(
            target: .networkKit,
            dependencies: [
                .target(name: .coreKit),
                .target(name: .model),
                .external(.alamofire),
                .external(.openapiGenerated)
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
