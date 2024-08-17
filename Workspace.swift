//
//  Workspace.swift
//  Config
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Weave2",
    projects: [
        "Projects/App",
        "Projects/Core",
        "Projects/DesignSystem",
        "Projects/Features"
    ],
    schemes: [
        .scheme(
            name: "Weave2-dev",
            buildAction: .buildAction(targets: [.project(path: "./Projects/App", target: AppConfig.dev.appName)]),
            runAction: .runAction(
                configuration: .debug,
                arguments: .arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])
            ),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        .scheme(
            name: "Weave2-prod",
            buildAction: .buildAction(targets: [.project(path: "./Projects/App", target: AppConfig.prod.appName)]),
            runAction: .runAction(
                configuration: .release,
                arguments: .arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])
            ),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
        ),
        .scheme(
            name: "Weave2-UnitTest",
            testAction: .targets(
                [
                    .testableTarget(
                        target: .project(
                            path: ".\(ProjectPath.core.rawValue)",
                            target: TargetName.coreKit.unitTestName
                        )
                    ),
                ]
            )
        ),
    ],
    generationOptions: .options(autogeneratedWorkspaceSchemes: .disabled)
)
