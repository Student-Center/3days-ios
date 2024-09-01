//
//  AuthStatus.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public class AuthState: ObservableObject {
    //MARK: State 정의
    public enum State {
        case loggedIn(accessToken: String?, refreshToken: String?)
        case loggedOut
        case signUp(registerToken: String?)
        
        func changeState() {
            switch self {
            case .loggedIn(let accessToken, let refreshToken):
                TokenManager.accessToken = accessToken
                TokenManager.refreshToken = refreshToken
                TokenManager.registerToken = nil
            case .loggedOut:
                TokenManager.accessToken = nil
                TokenManager.refreshToken = nil
                TokenManager.registerToken = nil
            case .signUp(let registerToken):
                TokenManager.accessToken = nil
                TokenManager.refreshToken = nil
                TokenManager.registerToken = registerToken
            }
        }
    }
    
    public static let shared = AuthState()
    private init() {}
    
    //MARK: Current
    @Published public private(set) var current: State = .loggedOut
    
    //MARK: - Update
    public func updateAuthState(to status: State) {
        status.changeState()
        self.current = status
    }
}
