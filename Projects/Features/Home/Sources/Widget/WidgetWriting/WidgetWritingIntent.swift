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
import DesignCore

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
        model.setSuccessHandler(handler: input.successHandler)
        if let contentString = input.content {
            model.setContentString(contentString)
        }
    }
}

//MARK: - Intentable
extension WidgetWritingIntent {
    protocol Intentable {
        // content
        func onChangedBodyText(_ text: String, maxCount: Int)
        func onTapNextButton(state: WidgetWritingModel.Stateful)
        func onTapBackButton()
        func onTapDismissButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let widgetType: WidgetType
        let content: String?
        let successHandler: (() -> Void)?
    }
}

//MARK: - Intentable
extension WidgetWritingIntent: WidgetWritingIntent.Intentable {
    // default
    func onChangedBodyText(_ text: String, maxCount: Int) {
        let formattedText = text.clipMaxCount(maxCount)
        model?.setBodyText(formattedText)
    }
    func onTapBackButton() {
        model?.navigationPop()
    }
    func onTapDismissButton() {
        model?.modalDismiss()
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
                model?.setLoading(status: false)
                model?.modalDismiss()
                model?.doSuccessAction()
            } catch {
                // TODO: 에러처리
                model?.setLoading(status: false)
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
