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
import DesignCore

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
        func onTapModifyDatePartnerProfile(_ type: DateProfileTab)
        
        func onTapNextButton()
        func refreshUserInfo() async
        func fetchUserInfo(_ userInfo: UserInfo)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension ProfileIntent: ProfileIntent.Intentable {
    // default
    func onTapAddWidget() {
        model?.setAddWidgetModalPresented(true)
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
            await refreshUserInfo()
            model?.setLoading(status: false)
            try await Task.sleep(for: .milliseconds(500))
            ToastHelper.show("위젯이 삭제되었어요")
        } catch {
            print(error)
            model?.setLoading(status: false)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
                ToastHelper.showErrorMessage()
            }
        }
    }
    
    func onTapModifyDatePartnerProfile(_ type: DateProfileTab) {
        Task {
            guard let userInfo = AppCoordinator.shared.userInfo else { return }
            switch type {
            case .ageRange:
                await pushEditDreamPartnerInfoView(.ageRange(userInfo))
            case .occupation:
                await pushEditDreamPartnerInfoView(.jobOccupation(userInfo))
            case .distance:
                await pushEditDreamPartnerInfoView(.distance(userInfo))
            }
        }
    }
    
    @MainActor
    func pushEditDreamPartnerInfoView(_ view: EditDreamPartnerViewType) {
        AppCoordinator.shared.push(.editDreamPartner(view))
    }
    
    func onAppear() {
        Task {
            await refreshUserInfo()
        }
    }
    
    func refreshUserInfo() async {
        if let userInfo = try? await AppCoordinator.shared.refreshMyUserInfo() {
            fetchUserInfo(userInfo)
        }
    }
    
    func fetchUserInfo(_ userInfo: UserInfo) {
        DispatchQueue.main.async {
            self.model?.setUserInfo(userInfo)
        }
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
    
    func requestDeleteWidget(_ widget: ProfileWidget) async throws {
        throw NSError(domain: "33", code: 33)
        try await profileService.requestDeleteProfileWidget(widgetType: widget.widgetType.toDto)
    }
}
