//
//  AppCoordinator.swift
//  CommonKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public final class AppCoordinator: ObservableObject {
    //MARK: - Lifecycle
    public static var shared = AppCoordinator()
    private init() {}
    
    //MARK: - Properties
    @Published public var navigationStack: [PathType] = [.main]
    
    //MARK: - Methods
    public func changeRootView(_ feature: PathType) {
        Task {
            await MainActor.run {
                navigationStack = [feature]
            }
        }
    }
}
