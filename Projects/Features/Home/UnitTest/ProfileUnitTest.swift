//
//  ProfileUnitTest.swift
//  Home-UnitTest
//
//  Created by 김지수 on 11/15/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Testing
import CommonKit
import NetworkKit
import Model
@testable import Home

struct ProfileUnitTest {
    
    let appCoordinator = AppCoordinator.shared
    let state: ProfileModel
    let intent: ProfileIntent
    
    init() {
        self.state = ProfileModel()
        self.intent = ProfileIntent(
            model: state,
            input: .init(userInfo: .mock),
            service: ProfileServiceMock()
        )
        appCoordinator.userInfo = .mock
        intent.onAppear()
    }
    
    @Test func onTapAddWidget() async throws {
        intent.onTapAddWidget()
        #expect(state.isPresentedAddWidgetModal == true)
    }

    @Test func modifyWidget() async throws {
        let widget = ProfileWidget(
            widgetType: .body,
            content: "이것은 콘텐츠으"
        )
        intent.onTapModifyWidget(widget)
        #expect(state.selectedWidgetType == widget)
        #expect(state.isPresentedModifyWidgetView == true)
    }
    
    @Test func onTapDelete() async throws {
        let widget = ProfileWidget(
            widgetType: .body,
            content: "이것은 콘텐츠으"
        )
        intent.onTapDeleteWidget(widget)
        #expect(state.selectedWidgetType == widget)
        #expect(state.isPresentedDeleteConfirmSheet == true)
    }
}
