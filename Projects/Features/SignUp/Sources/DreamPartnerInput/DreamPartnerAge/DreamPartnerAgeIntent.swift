//
//  DreamPartnerAgeIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class DreamPartnerAgeIntent {
    private weak var model: DreamPartnerAgeModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: DreamPartnerAgeModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension DreamPartnerAgeIntent {
    protocol Intentable {
        // content
        func onChangeUpperValue(value: String?)
        func onChangeLowerValue(value: String?)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension DreamPartnerAgeIntent: DreamPartnerAgeIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onChangeUpperValue(value: String?) {
        model?.setUpperValue(value: value)
    }
    func onChangeLowerValue(value: String?) {
        model?.setLowerValue(value: value)
    }
    func onTapNextButton() {
        Task {
            await pushNextView()
        }
    }
    
    @MainActor
    func pushNextView() {
        
    }
}
