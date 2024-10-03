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
    @MainActor
    public func changeRootView(_ path: PathType) {
        push(path)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 애니메이션 시간에 맞춰 조정
            self.navigationStack.removeFirst()
        }
    }
    
    @MainActor
    public func push(_ path: PathType) {
        navigationStack.append(path)
    }
    
    @MainActor
    public func pop() {
        guard navigationStack.count > 1 else { return }
        navigationStack.removeLast()
    }
}
