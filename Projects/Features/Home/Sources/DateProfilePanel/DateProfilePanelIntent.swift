//
//  DateProfilePanelIntent.swift
//  Home
//
//  Created by 김지수 on 11/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class DateProfilePanelIntent {
    private weak var model: DateProfilePanelModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: DateProfilePanelModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        model.setDreamPartnerInfo(input.dreamPartnerInfo)
    }
}

//MARK: - Intentable
extension DateProfilePanelIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let dreamPartnerInfo: DreamPartnerInfo
    }
}

//MARK: - Intentable
extension DateProfilePanelIntent: DateProfilePanelIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
