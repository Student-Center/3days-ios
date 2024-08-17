import Foundation
import ProjectDescription

let defaultSetting: SettingsDictionary = [
    "ENABLE_USER_SCRIPT_SANDBOXING": true,
    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true
]

extension Target {
    public static func make(
        name: String,
        destinations: Destinations = [.iPhone],
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String,
        deploymentTargets: DeploymentTargets? = nil,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false
    ) -> Target {
        
        var targetSettings: Settings? = settings
        
        if targetSettings != nil {
            targetSettings?.base.merge(defaultSetting)
        } else {
            targetSettings = .settings(
                base: defaultSetting
            )
        }
        
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            productName: productName,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: targetSettings,
            coreDataModels: coreDataModels,
            environmentVariables: environmentVariables,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules,
            mergedBinaryType: mergedBinaryType,
            mergeable: mergeable
        )
    }
    
    public static func make(
        target: TargetName,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .make(
            name: target.name,
            product: product,
            bundleId: "com.studentcenter.weave2-\(target.name)",
            sources: ["\(target.sources)"],
            dependencies: dependencies
        )
    }
    
    public static func makeAppTarget(
        config: AppConfig,
        destinations: Destinations = [.iPhone],
        infoPlist: InfoPlist? = .default,
        settings: Settings? = nil,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .make(
            name: config.appName,
            product: .app,
            bundleId: "com.studentcenter.weave2-\(config.flag)",
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies, 
            settings: settings
        )
    }
}
