//
//  EditProfileJobOccupationTest.swift
//  Home-UnitTest
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Testing
@testable import Home
import NetworkKit

struct EditProfileJobOccupationTests {
    
    let state: EditProfileJobModel
    let intent: EditProfileJobIntent
    
    init() {
        state = EditProfileJobModel()
        intent = EditProfileJobIntent(
            model: state,
            input: .init(userInfo: .mock),
            service: ProfileServiceMock()
        )
    }

    @Test func jobSelection() async throws {
        intent.onTapJobOccupation(
            selectedJob: .business
        )
        #expect(state.singleSelectedJob == .business)
    }
}
