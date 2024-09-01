//
//  Interceptor.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import CoreKit
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    private let retryLimit = 3
    private let retryDelay: TimeInterval = 1.5
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        
        // AccessToken 추가
        if let token = TokenManager.accessToken {
            urlRequest.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse, 
                response.statusCode == 401,
                request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        
        // refresh 토큰 갱신 후 retry
        Task {
            do {
//                try await refreshAccessToken()
                completion(.retryWithDelay(retryDelay))
            } catch {
                await MainActor.run {
                    AuthState.shared.updateAuthState(to: .loggedOut)
                }
                completion(.doNotRetry)
            }
        }
    }
    
//    private func refreshAccessToken() async throws {
//        let endpoint = AuthEndpoint.refreshToken
//        let response = try await endpoint.request(TokenResponse.self)
//        
//        TokenManager.accessToken = response.accessToken
//        TokenManager.refreshToken = response.refreshToken
//    }
}
