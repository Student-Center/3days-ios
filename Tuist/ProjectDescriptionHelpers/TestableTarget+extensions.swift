import Foundation
import ProjectDescription

extension TestableTarget {
    public static func target(_ target: TargetName) -> TestableTarget {
        return TestableTarget.testableTarget(
            target: .project(
                path: "./\(target.projectPath.rawValue)",
                target: target.unitTestName
            )
        )
    }
}
