import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist = InfoPlist.extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
        ],
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        "App Enviroment": "$(APP_ENV)",
        "CFBundleDisplayName": "${INFOPLIST_KEY_CFBundleDisplayName}"
    ]
)

let project: Project = .make(
    name: "App",
    targets: [
        .makeAppTarget(
            config: .dev,
            infoPlist: infoPlist,
            settings: .settings(
                base: BuildSetting.App.base(.dev),
                configurations: [
                    .debug(
                        name: .debug,
                        settings: BuildSetting.App.dev
                    ),
                    .release(
                        name: .release,
                        settings: BuildSetting.App.dev
                    )
                ]
            ),
            dependencies: [
                .project(target: .main)
            ]
        ),
        .makeAppTarget(
            config: .prod,
            infoPlist: infoPlist,
            settings: .settings(
                base: BuildSetting.App.base(.prod),
                configurations: [
                    .debug(
                        name: .debug,
                        settings: BuildSetting.App.prod
                    ),
                    .release(
                        name: .release,
                        settings: BuildSetting.App.prod
                    )
                ]
            ),
            dependencies: [
                .project(target: .main)
            ]
        ),
    ]
)

enum BuildSetting {
    enum App {
        static func base(_ config: AppConfig) -> SettingsDictionary {
            return [
                "MARKETING_VERSION": AppConfig.appVersion,
                "CURRENT_PROJECT_VERSION": AppConfig.buildNumber,
                "INFOPLIST_KEY_CFBundleDisplayName": config.appDisplayName
            ]
        }
        static let dev: SettingsDictionary = [
            "APP_ENV": "dev",
        ]
        static let prod: SettingsDictionary = [
            "APP_ENV": "prod"
        ]
    }
}
