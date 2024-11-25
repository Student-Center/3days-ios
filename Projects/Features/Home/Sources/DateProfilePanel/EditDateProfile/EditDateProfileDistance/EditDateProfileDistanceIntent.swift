//
//  EditDateProfileDistanceIntent.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class EditDateProfileDistanceIntent {
    private weak var model: EditDateProfileDistanceModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: EditDateProfileDistanceModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension EditDateProfileDistanceIntent {
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
extension EditDateProfileDistanceIntent: EditDateProfileDistanceIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
