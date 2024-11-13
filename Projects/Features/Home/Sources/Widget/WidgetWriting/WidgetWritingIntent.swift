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
import NetworkKit

//MARK: - Intent
class WidgetWritingIntent {
    private weak var model: WidgetWritingModelActionable?
    private let input: DataModel
    private let service: ProfileServiceProtocol

    // MARK: Life cycle
    init(
        model: WidgetWritingModelActionable,
        input: DataModel,
        service: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.service = service
        model.setWidgetType(input.widgetType)
    }
}

//MARK: - Intentable
extension WidgetWritingIntent {
    protocol Intentable {
        // content
        func onChangedBodyText(_ text: String, maxCount: Int)
        func onTapNextButton(state: WidgetWritingModel.Stateful)
        
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
        let formattedText = text.clipMaxCount(maxCount)
        model?.setBodyText(formattedText)
    }
    func onAppear() {
        model?.setFocusState(true)
    }
    
    func task() async {}
    
    // content
    func onTapNextButton(state: any WidgetWritingModel.Stateful) {
        guard let selectedWidget = state.selectedWidgetType else { return }
        // 창닫기
        Task {
            model?.setLoading(status: true)
            do {
                try await requestPutProfileWidget(
                    widget: selectedWidget,
                    content: state.widgetBodyText
                )
                try await AppCoordinator.shared.refreshMyUserInfo()
                model?.setLoading(status: false)
                model?.modalDismiss()
            } catch {
                print(error)
            }
        }
    }
    
    func requestPutProfileWidget(widget: WidgetType, content: String) async throws {
        try await service.requestPutProfileWidget(
            widgetType: widget.toDto,
            content: content
        )
    }
}
