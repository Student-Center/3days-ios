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
import Model
import DesignCore

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
        model.setUserInfo(input.userInfo)
        model.setDistanceType(input.userInfo.dreamPartner.distanceType)
    }
}

//MARK: - Intentable
extension EditDateProfileDistanceIntent {
    protocol Intentable {
        // content
        func onTapDistanceType(_ type: DreamPartnerDistanceType)
        func onTapNextButton(state: EditDateProfileDistanceModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditDateProfileDistanceIntent: EditDateProfileDistanceIntent.Intentable {
    func onTapDistanceType(_ type: DreamPartnerDistanceType) {
        model?.setDistanceType(type)
    }
    func onTapNextButton(state: any EditDateProfileDistanceModel.Stateful) {
        Task {
            do {
                guard let selectedDistanceType = state.selectedDistanceType else { return }
                model?.setLoading(status: true)
                var newUserInfo = input.userInfo
                newUserInfo.dreamPartner.distanceType = selectedDistanceType
                try await requestUpdatePartnerInfo(newUserInfo: newUserInfo)
                model?.setLoading(status: false)
                await MainActor.run {
                    AppCoordinator.shared.pop()
                }
            } catch {
                model?.setLoading(status: false)
                ToastHelper.showErrorMessage(error.localizedDescription)
            }
        }
    }
    func requestUpdatePartnerInfo(newUserInfo: UserInfo) async throws {
        
    }
    
    // default
    func onAppear() {}
    
    func task() async {}
}
