//
//  WidgetUnitTest.swift
//  Home-UnitTest
//
//  Created by 김지수 on 11/15/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Testing
@testable import Home

struct WidgetUnitTest {

    let widgetSelectionState: WidgetSelectionModel
    let widgetSelectionIntent: WidgetSelectionIntent
    
    init () {
        self.widgetSelectionState = WidgetSelectionModel()
        self.widgetSelectionIntent = WidgetSelectionIntent(
            model: widgetSelectionState,
            input: .init()
        )
    }

    @Test func someFunctions() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(widgetSelectionState.isValidated == false)
        let a = 0
        let b = 1
        #expect(a + b == 1)
        
    }
}
