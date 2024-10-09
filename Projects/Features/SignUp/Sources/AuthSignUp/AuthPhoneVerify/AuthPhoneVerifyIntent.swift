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
        model?.onChangedUserInput(value: code)
        if code.count == 6 {
            model?.setLoading(status: true)
            Task {
                do {
                    try await requestVerification(code: code)
                    let nextPath = getNextPath(userType: input.smsResponse.userType)
                    await pushNextView(to: nextPath)
                } catch {
                    processError(error: error)
                }
            }
        }
    }
    
    func onChangeFocusState(_ state: Bool) {
        model?.setTextFieldFocus(value: state)
    }
    
    func requestVerification(code: String) async throws {
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
        }
    }
    
    func processError(error: Error) {
        model?.setLoading(status: false)
        model?.resetText()
        model?.setTextFieldFocus(value: true)
        model?.showErrorAlert(
            error: .init(
                title: "에러 발생",
                message: error.localizedDescription
            )
        )
    }
    
    /// user type 에 따라 다음으로 이동할 뷰를 리턴합니다.
    func getNextPath(userType: UserType) -> PathType {
        switch userType {
        case .NEW: return .signUp(.authAgreement)
        case .EXISTING: return .main
        }
    }
    
    @MainActor
    func pushNextView(to targetPath: PathType) {
        AppCoordinator.shared.push(targetPath)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
