//
//  HomeMainIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 11/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import NetworkKit
import DesignCore

//MARK: - Intent
class HomeMainIntent {
    private weak var model: HomeMainModelActionable?
    private let input: DataModel
    private let authService: AuthServiceProtocol

    // MARK: Life cycle
    init(
        model: HomeMainModelActionable,
        input: DataModel,
        service: AuthServiceProtocol = AuthService.shared
    ) {
        self.input = input
        self.model = model
        self.authService = service
    }
}

//MARK: - Intentable
extension HomeMainIntent {
    protocol Intentable {
        // content
        func onTapTab(_ tab: HomeMainTab)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo?
    }
}

//MARK: - Intentable
extension HomeMainIntent: HomeMainIntent.Intentable {
    // default
    func onTapTab(_ tab: HomeMainTab) {
        model?.setSelectedTab(tab: tab)
    }
    func onAppear() {
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {
        ToastHelper.show(message: "토스트얍")
    }
}
