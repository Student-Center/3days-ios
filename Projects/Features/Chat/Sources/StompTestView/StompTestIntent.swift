//
//  StompTestIntent.swift
//  Chat
//
//  Created by 김지수 on 1/28/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import NetworkKit

//MARK: - Intent
class StompTestIntent {
    private weak var model: StompTestModelActionable?
    private let input: DataModel
    
    private let authService = AuthService.shared

    // MARK: Life cycle
    init(
        model: StompTestModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension StompTestIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func requestConnect()
        
        func onTapVerifyButton(phone: String)
        func onTapCustomToken(token: String)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension StompTestIntent: StompTestIntent.Intentable {
    // default
    func onAppear() {
        
    }
    
    func task() async {}
    
    func onTapVerifyButton(phone: String) {
        Task {
            do {
                let defaultCode = "123456"
                let phone = phone.replacingOccurrences(of: "-", with: "")
                let authCodeId = try await authService.requestSendSMS(phone: phone).authCodeId
                let result = try await authService.requestExistingUserVerifyCode(
                    .init(
                        verificationId: authCodeId,
                        verificationCode: defaultCode
                    )
                )
                model?.setAuthToken(token: result.accessToken)
            } catch {
                print(error)
            }
        }
    }
    
    func onTapCustomToken(token: String) {
        model?.setAuthToken(token: token)
    }
    
    // content
    func requestConnect() {
        StompClient.shared.connect()
    }
    func onTapNextButton() {}
}
