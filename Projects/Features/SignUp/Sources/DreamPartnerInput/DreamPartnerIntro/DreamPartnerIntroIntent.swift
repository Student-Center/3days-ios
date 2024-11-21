//
//  DreamPartnerIntroIntent.swift
//  SignUp
//
//  Created by 김지수 on 11/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class DreamPartnerIntroIntent {
    private weak var model: DreamPartnerIntroModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: DreamPartnerIntroModelActionable,
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
extension DreamPartnerIntroIntent {
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
extension DreamPartnerIntroIntent: DreamPartnerIntroIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    @MainActor
    func pushNextView() async {
        AppCoordinator.shared.changeRootView(
            .signUp(.dreamPartnerAgeRange(input: input.input))
        )
    }
    func onTapNextButton() {}
}
