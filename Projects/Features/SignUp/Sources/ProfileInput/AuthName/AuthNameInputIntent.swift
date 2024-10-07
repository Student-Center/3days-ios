//
//  AuthNameInputIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthNameInputIntent {
    private weak var model: AuthNameInputModelActionable?
    private let externalData: DataModel

    // MARK: Life cycle
    init(
        model: AuthNameInputModelActionable,
        externalData: DataModel
    ) {
        self.externalData = externalData
        self.model = model
    }
}

//MARK: - Intentable
extension AuthNameInputIntent {
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
extension AuthNameInputIntent: AuthNameInputIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
