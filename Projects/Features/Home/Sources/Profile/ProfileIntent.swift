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
import NetworkKit

//MARK: - Intent
class ProfileIntent {
    private weak var model: ProfileModelActionable?
    private let input: DataModel
    private let profileService: ProfileServiceProtocol

    // MARK: Life cycle
    init(
        model: ProfileModelActionable,
        input: DataModel,
        service: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.profileService = service
    }
}

//MARK: - Intentable
extension ProfileIntent {
    protocol Intentable {
        // content
        func onTapModifyWidget(_ widget: ProfileWidget)
        func onTapDeleteWidget(_ widget: ProfileWidget)
        func onTapAddWidget()
        func deleteWidget(_ widget: ProfileWidget) async
        
        func onTapNextButton()
        func fetchUserInfo(_ userInfo: UserInfo)
        
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
    func onTapAddWidget() {
        
    }
    
    func onTapDeleteWidget(_ widget: ProfileWidget) {
        model?.setSelectedWidget(widget)
        model?.setDeleteConfirmSheetPresented(true)
    }
    
    func onTapModifyWidget(_ widget: ProfileWidget) {
        model?.setSelectedWidget(widget)
        model?.setModifyWidgetViewPresented(true)
    }
    
    func deleteWidget(_ widget: ProfileWidget) async {
        do {
            model?.setLoading(status: true)
            try await requestDeleteWidget(widget)
            try await AppCoordinator.shared.refreshMyUserInfo()
            model?.setLoading(status: false)
        } catch {
            print(error)
            model?.setLoading(status: false)
        }
    }
    
    func onAppear() {
        fetchUserInfo(input.userInfo)
    }
    
    func fetchUserInfo(_ userInfo: UserInfo) {
        model?.setUserInfo(userInfo)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
    
    func requestDeleteWidget(_ widget: ProfileWidget) async throws {
        try await profileService.requestDeleteProfileWidget(widgetType: widget.widgetType.toDto)
    }
}
