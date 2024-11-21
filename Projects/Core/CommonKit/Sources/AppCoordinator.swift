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
    public var authState: AuthState = .none
    @Published public var userInfo: UserInfo?
    public var needFadeTransition: Bool = false
    @Published public var navigationStack: [PathType] = [.intro]
    let authService = AuthService.shared
    
    public var isRootView: Bool {
        navigationStack.count == 1
    }
    
    //MARK: - Methods
    private func setup() {
        AuthState.changeHandler = { [weak self] state in
            DispatchQueue.main.async {
                self?.authState = state
                if state == .loggedOut {
                    if self?.navigationStack != [.intro] {
                        self?.navigationStack = [.intro]
                    }
                    self?.userInfo = nil
                }
            }
        }
    }
    
    @MainActor
    public func changeRootView(_ path: PathType) {
        needFadeTransition = true
        navigationStack = [path]
    }
    
    @MainActor
    public func push(_ path: PathType) {
        needFadeTransition = false
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
                
                print("👉 accessToken: \(TokenManager.accessToken ?? "null")")
                print("👉 refreshToken: \(TokenManager.refreshToken ?? "null")")
                
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
    
    public func refreshMyUserInfo() async throws -> UserInfo? {
        if TokenManager.accessToken == nil || TokenManager.accessToken == "" {
            AuthState.change(.loggedOut)
            return nil
        }
        let userInfo = try await authService.requestMyUserInfo()
        await MainActor.run {
            self.userInfo = userInfo
            AuthState.change(.login)
        }
        return userInfo
    }
    
    public func logout() {
        TokenManager.accessToken = nil
        TokenManager.refreshToken = nil
        TokenManager.registerToken = nil
        AuthState.change(.loggedOut)
    }
}
