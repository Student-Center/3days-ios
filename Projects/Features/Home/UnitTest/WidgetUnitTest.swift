//
//  WidgetUnitTest.swift
//  Home-UnitTest
//
//  Created by 김지수 on 11/15/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Testing
@testable import Home
import NetworkKit

struct WidgetUnitTest {

    let selectionState: WidgetSelectionModel
    let selectionIntent: WidgetSelectionIntent
    
    let writeState: WidgetWritingModel
    let writeIntent: WidgetWritingIntent
    
    init () {
        self.selectionState = WidgetSelectionModel()
        self.selectionIntent = WidgetSelectionIntent(
            model: selectionState,
            input: .init(
                successHandler: {
                }
            )
        )
        
        self.writeState = WidgetWritingModel()
        self.writeIntent = WidgetWritingIntent(
            model: writeState,
            input: .init(
                widgetType: .body,
                content: nil
            ),
            service: ProfileServiceMock()
        )
        
        selectionIntent.onAppear()
        writeIntent.onAppear()
    }

    @Test func selectWidget() async throws {
        selectionIntent.onTapWidget(.body)
        #expect(selectionState.selectedWidget == .body)
        #expect(selectionState.isPushWriteContentView == true)
    }
    
    @Test func writeWidgetContent() async throws {
        let content: String = "Hello, World!"
        writeIntent.onChangedBodyText(content, maxCount: 15)
        #expect(writeState.widgetBodyText == content)
        let longContent: String = "Hello World!! This is Hipster Text! Oh YEAH!!"
        writeIntent.onChangedBodyText(longContent, maxCount: 15)
        #expect(writeState.widgetBodyText == "Hello World!! T")
        #expect(writeState.widgetBodyText.count == 15)
    }
    
    @Test func onTapBackButton() async throws {
        writeIntent.onTapBackButton()
        writeState.isPushedWriteContentView = false
    }
    
    @Test func onTapDismissButton() async throws {
        writeIntent.onTapDismissButton()
        writeState.isPushedWriteContentView = false
    }
    
    @Test func keyboardFocusState() async throws {
        #expect(writeState.isFocused == true)
    }
    
    @Test func onTapNextButton() async throws {
        writeIntent.onTapNextButton(state: writeState)
        // 3초 후 실행
        try await Task.sleep(for: .seconds(1))
        #expect(writeState.isModalPresented == false)
    }
}
