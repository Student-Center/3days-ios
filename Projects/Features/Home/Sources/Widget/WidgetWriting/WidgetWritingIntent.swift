//
//  WidgetWritingIntent.swift
//  Home
//
//  Created by 김지수 on 11/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class WidgetWritingIntent {
    private weak var model: WidgetWritingModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: WidgetWritingModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        model.setWidgetType(input.widgetType)
    }
}

//MARK: - Intentable
extension WidgetWritingIntent {
    protocol Intentable {
        // content
        func onChangedBodyText(_ text: String, maxCount: Int)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let widgetType: WidgetType
    }
}

//MARK: - Intentable
extension WidgetWritingIntent: WidgetWritingIntent.Intentable {
    // default
    func onChangedBodyText(_ text: String, maxCount: Int) {
        if text.count > maxCount {
            return
        }
        model?.setBodyText(text)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
