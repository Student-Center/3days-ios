//
//  AuthCompanyIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthCompanyIntent {
    private weak var model: AuthCompanyModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthCompanyModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthCompanyIntent {
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
extension AuthCompanyIntent: AuthCompanyIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
