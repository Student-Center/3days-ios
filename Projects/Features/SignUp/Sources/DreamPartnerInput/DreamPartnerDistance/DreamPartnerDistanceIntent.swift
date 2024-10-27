//
//  DreamPartnerDistanceIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import NetworkKit

//MARK: - Intent
class DreamPartnerDistanceIntent {
    private weak var model: DreamPartnerDistanceModelActionable?
    private let input: DataModel
    private let authService: AuthServiceProtocol

    // MARK: Life cycle
    init(
        model: DreamPartnerDistanceModelActionable,
        input: DataModel,
        service: AuthServiceProtocol = AuthService.shared
    ) {
        self.input = input
        self.model = model
        self.authService = service
    }
}

//MARK: - Intentable
extension DreamPartnerDistanceIntent {
    protocol Intentable {
        // content
        func onTapDistanceType(_ type: DreamPartnerDistanceType)
        func onTapNextButton(state: DreamPartnerDistanceModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension DreamPartnerDistanceIntent: DreamPartnerDistanceIntent.Intentable {
    // default
    func onTapDistanceType(_ type: DreamPartnerDistanceType) {
        model?.setDistanceType(type)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton(
        state: DreamPartnerDistanceModel.Stateful
    ) {
        Task {
            var payload = input.input
            payload.dreamPartner?.distanceType = state.selectedDistanceType
            await requestSignUp(payload: payload)
        }
    }
    
    func requestSignUp(payload: SignUpFormDomain) async {
        do {
            let response = try await authService.requestSignUp(
                domain: payload
            )
            TokenManager.accessToken = response.accessToken
            TokenManager.refreshToken = response.refreshToken
            await pushNextView()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func pushNextView() {
        AppCoordinator.shared.push(.authDebug)
    }
}
