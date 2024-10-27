//
//  AuthNameInputIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class AuthNameInputIntent {
    private weak var model: AuthNameInputModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthNameInputModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthNameInputIntent {
    protocol Intentable {
        // content
        func onChangeInputText(text: String)
        func onTapNextButton(state: AuthNameInputModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension AuthNameInputIntent: AuthNameInputIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onChangeInputText(text: String) {
        model?.setInputText(text)
    }
    func onTapNextButton(state: AuthNameInputModel.Stateful) {
        Task {
            var payload = input.input
            payload.name = state.inputText
            print(state.inputText)
            await pushNextView(payload: payload)
        }
    }
    
    @MainActor
    func pushNextView(payload: SignUpFormDomain) {
        AppCoordinator.shared.push(
            .signUp(
                .dreamPartnerAgeRange(
                    input: payload
                )
            )
        )
    }
}
