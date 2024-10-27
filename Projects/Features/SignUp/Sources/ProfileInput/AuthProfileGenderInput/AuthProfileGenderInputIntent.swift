//
//  AuthProfileGenderInputIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class AuthProfileGenderInputIntent {
    private weak var model: AuthProfileGenderInputModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthProfileGenderInputModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthProfileGenderInputIntent {
    protocol Intentable {
        // content
        func onTapGender(_ gender: GenderType)
        func onTapNextButton(_ gender: GenderType)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension AuthProfileGenderInputIntent: AuthProfileGenderInputIntent.Intentable {
    // default
    func onTapGender(_ gender: GenderType) {
        model?.setGender(gender)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton(_ gender: GenderType) {
        Task {
            var payload = input.input
            payload.profile?.gender = gender
            await pushNextView(payload: payload)
        }
    }
    
    @MainActor
    func pushNextView(payload: SignUpFormDomain) {
        AppCoordinator.shared.push(
            .signUp(.authProfileAge(input: payload))
        )
    }
}
