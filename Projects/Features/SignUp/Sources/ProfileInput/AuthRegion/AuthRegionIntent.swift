//
//  AuthRegionIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthRegionIntent {
    private weak var model: AuthRegionModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthRegionModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthRegionIntent {
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
extension AuthRegionIntent: AuthRegionIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
