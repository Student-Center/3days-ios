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
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
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
    func onTapNextButton() {
        Task {
            await AppCoordinator.shared.push(
                .signUp(.authProfileAge)
            )
        }
    }
}
