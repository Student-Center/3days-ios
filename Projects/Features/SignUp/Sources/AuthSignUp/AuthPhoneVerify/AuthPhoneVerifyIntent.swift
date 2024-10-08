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

//MARK: - Intent
class AuthPhoneVerifyIntent {
    private weak var model: AuthPhoneVerifyModelActionable?
    private let externalData: DataModel

    // MARK: Life cycle
    init(
        model: AuthPhoneVerifyModelActionable,
        externalData: DataModel
    ) {
        self.externalData = externalData
        self.model = model
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
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthPhoneVerifyIntent: AuthPhoneVerifyIntent.Intentable {
    // default
    func onAppear() {
        model?.setTextFieldFocus(value: true)
    }
    
    func onChangeVerifyCode(code: String) {
        if code.count == 6 {
            Task {
                await pushNextView()
            }
        }
    }
    
    func onChangeFocusState(_ state: Bool) {
        model?.setTextFieldFocus(value: state)
    }
    
    @MainActor
    func pushNextView() {
        AppCoordinator.shared.push(.signUp(.authAgreement))
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
