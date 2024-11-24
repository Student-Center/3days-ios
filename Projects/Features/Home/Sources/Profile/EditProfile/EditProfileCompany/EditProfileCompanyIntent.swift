//
//  EditProfileCompanyIntent.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class EditProfileCompanyIntent {
    private weak var model: EditProfileCompanyModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: EditProfileCompanyModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension EditProfileCompanyIntent {
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
extension EditProfileCompanyIntent: EditProfileCompanyIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
