//
//  DreamPartnerDistanceIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import SignUpDomain

//MARK: - Intent
class DreamPartnerDistanceIntent {
    private weak var model: DreamPartnerDistanceModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: DreamPartnerDistanceModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension DreamPartnerDistanceIntent {
    protocol Intentable {
        // content
        func onTapDistanceType(_ type: DreamPartnerDistanceType)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension DreamPartnerDistanceIntent: DreamPartnerDistanceIntent.Intentable {
    // default
    func onTapDistanceType(_ type: DreamPartnerDistanceType) {
        model?.setDistanceType(type)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
