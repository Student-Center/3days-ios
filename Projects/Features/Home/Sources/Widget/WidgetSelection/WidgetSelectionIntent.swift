//
//  WidgetSelectionIntent.swift
//  Home
//
//  Created by 김지수 on 11/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

//MARK: - Intent
class WidgetSelectionIntent {
    private weak var model: WidgetSelectionModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: WidgetSelectionModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        self.model?.setSuccessHandler(handler: input.successHandler)
    }
}

//MARK: - Intentable
extension WidgetSelectionIntent {
    protocol Intentable {
        // content
        func onTapWidget(_ widget: WidgetType)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let successHandler: (() -> Void)?
    }
}

//MARK: - Intentable
extension WidgetSelectionIntent: WidgetSelectionIntent.Intentable {
    // default
    func onTapWidget(_ widget: WidgetType) {
        model?.setSelectedWidget(widget: widget)
        model?.setPushWriteContentView(status: true)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
