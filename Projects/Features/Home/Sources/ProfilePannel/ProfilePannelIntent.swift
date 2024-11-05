//
//  ProfilePannelIntent.swift
//  Home
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class ProfilePannelIntent {
    private weak var model: ProfilePannelModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: ProfilePannelModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension ProfilePannelIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let name: String
        let profile: UserInfoProfile
    }
}

//MARK: - Intentable
extension ProfilePannelIntent: ProfilePannelIntent.Intentable {
    // default
    func onAppear() {
        model?.setProfile(profile: input.profile)
        model?.setName(name: input.name)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
