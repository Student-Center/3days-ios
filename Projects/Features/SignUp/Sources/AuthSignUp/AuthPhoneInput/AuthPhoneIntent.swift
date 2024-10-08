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

//MARK: - Intent
class AuthPhoneInputIntent {
    private weak var model: AuthPhoneInputActionable?
    private let externalData: DataModel

    // MARK: Life cycle
    init(
        model: AuthPhoneInputActionable,
        externalData: DataModel
    ) {
        self.externalData = externalData
        self.model = model
    }
}

//MARK: - Intentable
extension AuthPhoneInputIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func onChangePhoneInput(phone: String)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: String
    }
}

//MARK: - Intentable
extension AuthPhoneInputIntent: AuthPhoneInputIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    @MainActor
    func onTapNextButton() {
        AppCoordinator.shared.push(
            .signUp(
                .authPhoneVerify
            )
        )
    }
    
    func onChangePhoneInput(phone: String) {
        let editedPhone = phone.formattedPhoneNumber()
        let isPhoneValidated = editedPhone.isValidPhoneNumber()
        model?.setEditedPhoneText(phone: editedPhone)
        model?.setPhoneValidated(value: isPhoneValidated)
    }
}
