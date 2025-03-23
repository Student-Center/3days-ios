//
//  CardFullScreenIntent.swift
//  Chat
//
//  Created by 김지수 on 3/18/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class CardFullScreenIntent {
    private weak var model: CardFullScreenModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: CardFullScreenModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension CardFullScreenIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let card: ChatCard
    }
}

//MARK: - Intentable
extension CardFullScreenIntent: CardFullScreenIntent.Intentable {
    // default
    func onAppear() {
        model?.setCardData(card: input.card)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
