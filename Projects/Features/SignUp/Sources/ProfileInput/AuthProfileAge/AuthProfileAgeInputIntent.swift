//
//  AuthProfileAgeInputIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/6/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthProfileAgeInputIntent {
    private weak var model: AuthProfileAgeInputModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthProfileAgeInputModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        
    }
}

//MARK: - Intentable
extension AuthProfileAgeInputIntent {
    protocol Intentable {
        // content
        func onFocusChanged(_ value: Bool)
        func onTapNextButton()
        func onYearChanged(_ year: String)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let targetGender: GenderType
    }
}

//MARK: - Intentable
extension AuthProfileAgeInputIntent: AuthProfileAgeInputIntent.Intentable {
    // default
    func onAppear() {
        model?.setTargetGender(input.targetGender)
    }
    
    func task() async {}
    
    // content
    func onYearChanged(_ year: String) {
        guard let intYear = Int(year) else { return }
        if intYear > 1990 && intYear < 2010 {
            model?.setValidation(value: true)
        } else {
            model?.setValidation(value: false)
        }
    }
    func onFocusChanged(_ value: Bool) {
        model?.setFocuse(value)
    }
    func onTapNextButton() {
        Task {
            // TODO: 순서 재정의
            await AppCoordinator.shared.push(
                .signUp(.authName)
            )
        }
    }
}
