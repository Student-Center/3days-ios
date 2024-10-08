//
//  AuthAgreementIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthAgreementIntent {
    private weak var model: AuthAgreementModelActionable?
    private let externalData: DataModel

    // MARK: Life cycle
    init(
        model: AuthAgreementModelActionable,
        externalData: DataModel
    ) {
        self.externalData = externalData
        self.model = model
    }
}

//MARK: - Intentable
extension AuthAgreementIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthAgreementIntent: AuthAgreementIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {
        Task {
            await AppCoordinator.shared.changeRootView(
                .signUp(.authGreeting)
            )
        }
    }
}
