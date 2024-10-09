//
//  AuthPhoneIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import NetworkKit
import Model

//MARK: - Intent
class AuthPhoneInputIntent {
    private weak var model: AuthPhoneInputActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthPhoneInputActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthPhoneInputIntent {
    protocol Intentable {
        // content
        func onTapNextButton(with Phone: String)
        func onChangePhoneInput(phone: String)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthPhoneInputIntent: AuthPhoneInputIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton(with Phone: String) {
        model?.setLoading(status: true)
        Task {
            await requestSendSMS(phone: Phone)
        }
    }
    
    func requestSendSMS(phone: String) async {
        do {
            let editedPhone = phone.replacingOccurrences(
                of: "-",
                with: ""
            )
            let response = try await AuthService.requestSendSMS(phone: editedPhone)
            await pushNextView(smsResponse: response)
        } catch {
            // TODO: Error 타입 정의
            model?.showErrorAlert(
                error: .init(
                    title: "오류 발생",
                    message: "다시 시도해주세요"
                )
            )
        }
    }
    
    func onChangePhoneInput(phone: String) {
        var editedPhone = phone.formattedPhoneNumber()
        if editedPhone.count < 4 {
            editedPhone = "010-"
        }
        let isPhoneValidated = editedPhone.isValidPhoneNumber()
        model?.setEditedPhoneText(phone: editedPhone)
        model?.setPhoneValidated(value: isPhoneValidated)
    }
    
    @MainActor
    func pushNextView(smsResponse: SMSSendResponse) {
        print(#function)
        AppCoordinator.shared.push(
            .signUp(
                .authPhoneVerify(smsResponse)
            )
        )
    }
}
