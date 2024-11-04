//
//  ProfileIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class ProfileIntent {
    private weak var model: ProfileModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: ProfileModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension ProfileIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension ProfileIntent: ProfileIntent.Intentable {
    // default
    func onAppear() {
        model?.setUserInfo(input.userInfo)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
