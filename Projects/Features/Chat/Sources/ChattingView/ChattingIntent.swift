//
//  ChattingIntent.swift
//  Chat
//
//  Created by 김지수 on 2/4/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class ChattingIntent {
    private weak var model: ChattingModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: ChattingModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension ChattingIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension ChattingIntent: ChattingIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
