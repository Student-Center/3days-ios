//
//  AuthStatus.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public class AuthState: ObservableObject {
    
    public enum State {
        case loggedIn
        case loggedOut
    }
    
    public static let shared = AuthState()
    
    private init() {}
    
    @Published public private(set) var current: State = .loggedOut
    
    public func updateAuthState(to status: State) {
        self.current = status
    }
}
