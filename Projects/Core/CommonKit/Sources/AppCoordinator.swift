//
//  AppCoordinator.swift
//  CommonKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import NetworkKit
import Model
import CoreKit

public final class AppCoordinator: ObservableObject {
    //MARK: - Lifecycle
    public static var shared = AppCoordinator()
    private init() {
        setup()
        validateToken()
    }
    
    //MARK: - Properties
    @Published public var authState: AuthState = .none
    @Published public var userInfo: UserInfo?
    @Published public var navigationStack: [PathType] = [.main]
    let authService = AuthService.shared
    
    //MARK: - Methods
    private func setup() {
        AuthState.changeHandler = { [weak self] state in
            DispatchQueue.main.async {
                self?.authState = state
            }
        }
    }
    
    @MainActor
    public func changeRootView(_ path: PathType) {
        navigationStack = [path]
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
    
    public func validateToken(
        accessToken: String? = nil,
        refreshToken: String? = nil
    ) {
        Task {
            do {
                var accessToken = accessToken
                var refreshToken = refreshToken
                
                if accessToken == nil {
                    accessToken = TokenManager.accessToken
                }
                if refreshToken == nil {
                    refreshToken = TokenManager.refreshToken
                }
                guard accessToken != nil && accessToken != "" else {
                    await MainActor.run {
                        AuthState.change(.loggedOut)
                    }
                    return
                }
                let userInfo = try await authService.requestMyUserInfo()
                await MainActor.run {
                    self.userInfo = userInfo
                    AuthState.change(.login)
                }
            } catch {
                await MainActor.run {
                    AuthState.change(.loggedOut)
                }
            }
        }
    }
}
