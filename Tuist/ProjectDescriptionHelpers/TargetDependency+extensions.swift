import Foundation
import ProjectDescription

extension TargetDependency {
    public static func external(externalDependency: ExternalDependency) -> TargetDependency {
        return .external(name: externalDependency.rawValue)
    }
    
    public static func target(name: TargetName) -> TargetDependency {
        return .target(name: name.rawValue)
    }
    
    public static func project(target: TargetName) -> TargetDependency {
        return .project(
            target: target.rawValue,
            path: .relativeToRoot(target.projectPath.rawValue)
        )
    }
}
