//
//  WidgetWritingView.swift
//  Home
//
//  Created by 김지수 on 11/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct WidgetWritingView: View {
    
    @Binding var isPushed: Bool
    @Binding var isModalPresented: Bool
    
    @FocusState var isFocused: Bool
    let isEditingMode: Bool
    let contentString: String?
    
    @StateObject var container: MVIContainer<WidgetWritingIntent.Intentable, WidgetWritingModel.Stateful>
    
    private var intent: WidgetWritingIntent.Intentable { container.intent }
    private var state: WidgetWritingModel.Stateful { container.model }

    private var size: CGFloat {
        Device.height * 0.25
    }
    
    private var navigationTitle: String {
        if isEditingMode {
            return "프로필 위젯 수정"
        }
        return state.selectedWidgetType?.title ?? ""
    }
    
    public init(
        widgetType: WidgetType,
        isModalPresented: Binding<Bool>,
        isPushed: Binding<Bool>,
        isEditing: Bool = false,
        contentString: String? = nil
    ) {
        let model = WidgetWritingModel()
        let intent = WidgetWritingIntent(
            model: model,
            input: .init(widgetType: widgetType, content: contentString)
        )
        let container = MVIContainer(
            intent: intent as WidgetWritingIntent.Intentable,
            model: model as WidgetWritingModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
        self._isModalPresented = isModalPresented
        self._isPushed = isPushed
        self.isEditingMode = isEditing
        self.contentString = contentString
    }
    
    public var body: some View {
        VStack {
            if let widget = state.selectedWidgetType {
                Text("최대 40자 이내로 자유롭게 작성해주세요!")
                    .typography(.regular_14)
                    .padding(.vertical, 20)
                
                WritableProfileWidgetView(
                    title: widget.title + widget.emoji,
                    placeholder: widget.exampleText,
                    bodyText: $container.model.widgetBodyText,
                    titleColor: widget.titleColor,
                    bodyColor: widget.bodyColor,
                    gradientColors: widget.gradationColors,
                    focusState: _isFocused
                )
                .frame(width: size, height: size)
                .onChange(of: state.widgetBodyText) {
                    intent.onChangedBodyText(
                        state.widgetBodyText,
                        maxCount: state.textMaxCount
                    )
                }
                .onChange(of: state.isFocused) {
                    self.isFocused = state.isFocused
                }
            }
            
            HStack(spacing: 0) {
                Text(String(state.widgetBodyText.count))
                    .foregroundStyle(DesignCore.Colors.blue300)
                Text("/\(state.textMaxCount)")
                    .foregroundStyle(DesignCore.Colors.grey300)
            }
            .typography(.regular_15)
            Spacer()
            
            CTABottomButton(
                title: "다 썻어요",
                isActive: state.isCTAButtonEnabled
            ) {
                intent.onTapNextButton(state: state)
            }
        }
        .onChange(of: state.isModalPresented) {
            isModalPresented = state.isModalPresented
        }
        .onChange(of: state.isPushedWriteContentView) {
            isPushed = state.isPushedWriteContentView
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .setNavigation(
            showLeftBackButton: isEditingMode ? false : true,
            handler: {
                intent.onTapBackButton()
        })
        .toolbar {
            if isEditingMode {
                ToolbarItem {
                    Button("닫기") {
                        intent.onTapDismissButton()
                    }
                    .typography(.medium_16)
                }
            }
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        WidgetWritingView(
            widgetType: .body,
            isModalPresented: .constant(false),
            isPushed: .constant(false)
        )
    }
}
