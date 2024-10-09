//
//  AuthPhoneVerifyIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/4/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import NetworkKit
import Model

//MARK: - Intent
class AuthPhoneVerifyIntent {
    private weak var model: AuthPhoneVerifyModelActionable?
    private let input: DataModel
    private let authService: AuthServiceProtocol

    // MARK: Life cycle
    init(
        model: AuthPhoneVerifyModelActionable,
        input: DataModel,
        service: AuthServiceProtocol = AuthService.shared
    ) {
        self.input = input
        self.model = model
        self.authService = service
    }
}

//MARK: - Intentable
extension AuthPhoneVerifyIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func onChangeVerifyCode(code: String)
        func onChangeFocusState(_ state: Bool)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let smsResponse: SMSSendResponse
    }
}

//MARK: - Intentable
extension AuthPhoneVerifyIntent: AuthPhoneVerifyIntent.Intentable {
    // default
    func onAppear() {
        model?.setTextFieldFocus(value: true)
        model?.setInitialPhoneNumber(
            input.smsResponse.phoneNumber
        )
    }
    
    func onChangeVerifyCode(code: String) {
        if code.count == 6 {
            Task {
                model?.setLoading(status: true)
                await requestVerification(code: code)
            }
        }
    }
    
    func onChangeFocusState(_ state: Bool) {
        model?.setTextFieldFocus(value: state)
    }
    
    func requestVerification(code: String) async {
        do {
            switch input.smsResponse.userType {
            case .NEW:
                let registerToken = try await authService.requestNewUserVerifyCode(
                    .init(
                        verificationId: input.smsResponse.authCodeId,
                        verificationCode: code
                    )
                )
                // New User - 회원가입 뷰로 이동
                TokenManager.registerToken = registerToken
                await processSignUp()
                
            case .EXISTING:
                let response = try await authService.requestExistingUserVerifyCode(
                    .init(
                        verificationId: input.smsResponse.authCodeId,
                        verificationCode: code
                    )
                )
                // Existing User - 메인 뷰로 이동
                TokenManager.accessToken = response.accessToken
                TokenManager.refreshToken = response.refreshToken
                await pushToHomeview()
            }
        } catch {
            model?.setLoading(status: false)
            model?.resetText()
            model?.showErrorAlert(
                error: .init(
                    title: "에러 발생",
                    message: error.localizedDescription
                )
            )
        }
    }
    
    @MainActor
    func processSignUp() {
        AppCoordinator.shared.push(.signUp(.authAgreement))
    }
    
    @MainActor
    func pushToHomeview() {
        AppCoordinator.shared.push(.main)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
