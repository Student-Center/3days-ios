//
//  ProfileIntroIntent.swift
//  SignUp
//
//  Created by 김지수 on 11/20/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class ProfileIntroIntent {
    private weak var model: ProfileIntroModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: ProfileIntroModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        
        Task {
            try? await Task.sleep(for: .milliseconds(2500))
            await pushNextView()
        }
    }
}

//MARK: - Intentable
extension ProfileIntroIntent {
    protocol Intentable {
        // content
        func pushNextView() async
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension ProfileIntroIntent: ProfileIntroIntent.Intentable {
    // default
    @MainActor
    func pushNextView() async {
        AppCoordinator.shared.changeRootView(
            .signUp(.authProfileGender(input: input.input))
        )
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
