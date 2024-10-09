import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist = InfoPlist.extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
        ],
        "CFBundleShortVersionString": .string(AppConfig.appVersion),
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        "App Enviroment": "$(APP_ENV)",
        "CFBundleDisplayName": "${INFOPLIST_KEY_CFBundleDisplayName}",
        "UIUserInterfaceStyle": "Light",
        "ITSAppUsesNonExemptEncryption": false,
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ]
    ]
)

let appDependencies: [TargetDependency] = [
    .project(target: .main),
    .project(target: .signUp),
    .project(target: .designPreview)
]

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
                        settings: BuildSetting.App.dev_debug
                    ),
                    .release(
                        name: .configuration("Staging"),
                        settings: BuildSetting.App.dev_release
                    ),
                    .release(
                        name: .release,
                        settings: BuildSetting.App.dev_release
                    )
                ]
            ),
            dependencies: appDependencies
        ),
        .makeAppTarget(
            config: .prod,
            infoPlist: infoPlist,
            settings: .settings(
                base: BuildSetting.App.base(.prod),
                configurations: [
                    .debug(
                        name: .debug,
                        settings: BuildSetting.App.prod_debug
                    ),
                    .release(
                        name: .configuration("Staging"),
                        settings: BuildSetting.App.prod_release
                    ),
                    .release(
                        name: .release,
                        settings: BuildSetting.App.prod_release
                    )
                ]
            ),
            dependencies: appDependencies
        ),
    ]
)

enum BuildSetting {
    enum App {
        static func base(_ config: AppConfig) -> SettingsDictionary {
            return [
                "MARKETING_VERSION": AppConfig.appVersionValue,
                "CURRENT_PROJECT_VERSION": AppConfig.buildNumber,
                "INFOPLIST_KEY_CFBundleDisplayName": config.appDisplayName
            ]
        }
        static let dev_debug: SettingsDictionary = [
            "APP_ENV": "dev",
            "DEVELOPMENT_TEAM": "846TMZL7WC",
            "CODE_SIGN_STYLE": "Automatic",
        ]
        
        static let dev_release: SettingsDictionary = [
            "APP_ENV": "dev",
            "CODE_SIGN_STYLE": "Manual",
            "DEVELOPMENT_TEAM": "846TMZL7WC",
            "CODE_SIGN_IDENTITY": "iPhone Distribution",
            "PROVISIONING_PROFILE_SPECIFIER": "3days-dev"
        ]
        
        static let prod_debug: SettingsDictionary = [
            "APP_ENV": "prod",
            "DEVELOPMENT_TEAM": "846TMZL7WC",
            "CODE_SIGN_STYLE": "Automatic"
        ]
        
        static let prod_release: SettingsDictionary = [
            "APP_ENV": "prod",
            "CODE_SIGN_STYLE": "Manual",
            "DEVELOPMENT_TEAM": "846TMZL7WC",
            "CODE_SIGN_IDENTITY": "iPhone Distribution",
            "PROVISIONING_PROFILE_SPECIFIER": "3days-prod"
        ]
    }
}
