//
//  StompTestIntent.swift
//  Chat
//
//  Created by 김지수 on 1/28/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import NetworkKit

//MARK: - Intent
class StompTestIntent {
    private weak var model: StompTestModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: StompTestModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension StompTestIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func requestConnect()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension StompTestIntent: StompTestIntent.Intentable {
    // default
    func onAppear() {
        
    }
    
    func task() async {}
    
    // content
    func requestConnect() {
        StompClient.shared.connect()
    }
    func onTapNextButton() {}
}
