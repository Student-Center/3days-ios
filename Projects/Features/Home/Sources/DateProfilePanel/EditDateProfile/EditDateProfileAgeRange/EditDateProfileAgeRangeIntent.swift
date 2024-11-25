//
//  EditDateProfileAgeRangeIntent.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import NetworkKit
import DesignCore

//MARK: - Intent
class EditDateProfileAgeRangeIntent {
    private weak var model: EditDateProfileAgeRangeModelActionable?
    private let input: DataModel
    private let profileService: ProfileServiceProtocol

    // MARK: Life cycle
    init(
        model: EditDateProfileAgeRangeModelActionable,
        input: DataModel,
        service: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.profileService = service
        model.setUserInfo(input.userInfo)
    }
}

//MARK: - Intentable
extension EditDateProfileAgeRangeIntent {
    protocol Intentable {
        // content
        func onChangeUpperValue(value: String?)
        func onChangeLowerValue(value: String?)
        func onTapNextButton(state: EditDateProfileAgeRangeModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditDateProfileAgeRangeIntent: EditDateProfileAgeRangeIntent.Intentable {
    // default
    func onAppear() {
        if let upperYear = input.userInfo.dreamPartner.upperBirthYear {
            model?.setUpperValue(value: String(upperYear))
        }
        if let lowerYear = input.userInfo.dreamPartner.lowerBirthYear {
            model?.setLowerValue(value: String(lowerYear))
        }
    }
    
    func task() async {}
    
    // content
    func onChangeUpperValue(value: String?) {
        model?.setUpperValue(value: value)
    }
    func onChangeLowerValue(value: String?) {
        model?.setLowerValue(value: value)
    }
    func onTapNextButton(state: EditDateProfileAgeRangeModel.Stateful) {
        Task {
            do {
                model?.setLoading(status: true)
                var newUserInfo = input.userInfo
                newUserInfo.dreamPartner.upperBirthYear = state.upperValue
                    .flatMap { Int($0) }
                newUserInfo.dreamPartner.lowerBirthYear = state.lowerValue
                    .flatMap { Int($0) }
                try await requestUpdatePartnerInfo(newUserInfo: newUserInfo)
                model?.setLoading(status: false)
                await popView()
            } catch {
                model?.setLoading(status: false)
                ToastHelper.showErrorMessage(error.localizedDescription)
            }
        }
    }
    func requestUpdatePartnerInfo(newUserInfo: UserInfo) async throws {
        try await profileService.requestPutPartnerInfo(
            userInfo: newUserInfo
        )
    }
    @MainActor
    func popView() {
        AppCoordinator.shared.pop()
    }
}
