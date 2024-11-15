//
//  WidgetSelectionView.swift
//  Home
//
//  Created by 김지수 on 11/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct WidgetSelectionView: View {
    
//    @State private var isPushedWriteView: Bool = false
    
    @Binding var isPresentedSelectionView: Bool
    @StateObject var container: MVIContainer<WidgetSelectionIntent.Intentable, WidgetSelectionModel.Stateful>
    
    private var intent: WidgetSelectionIntent.Intentable { container.intent }
    private var state: WidgetSelectionModel.Stateful { container.model }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init(isPresented: Binding<Bool>) {
        let model = WidgetSelectionModel()
        let intent = WidgetSelectionIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as WidgetSelectionIntent.Intentable,
            model: model as WidgetSelectionModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
        self._isPresentedSelectionView = isPresented
        model.setModalPresented(status: isPresented.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            Text("추가하고 싶은 프로필 위젯을 눌러 소개를 작성해요!")
                .typography(.regular_14)
                .padding(.top, 20)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    let totalWidgets = WidgetType.allCases
                    let userWidgets = AppCoordinator.shared.userInfo?.profileWidgets
                        .map { $0.widgetType } ?? []
                    let availableWidgets = totalWidgets
                        .filter { !userWidgets.contains($0) }
                    
                    ForEach(availableWidgets, id: \.self) { widget in
                        ProfileWidgetView(
                            title: widget.title + widget.emoji,
                            bodyText: widget.exampleText,
                            titleColor: widget.titleColor,
                            bodyColor: widget.bodyColor,
                            gradientColors: widget.gradationColors,
                            iconType: .add
                        )
                        .onTapGesture {
                            intent.onTapWidget(widget)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationDestination(
            isPresented: $container.model.isPushWriteContentView,
            destination: {
                if let widget = state.selectedWidget {
                    WidgetWritingView(
                        widgetType: widget,
                        isModalPresented: $container.model.isModalPresented,
                        isPushed: $container.model.isPushWriteContentView
                    )
                }
            }
        )
        .onChange(of: state.isModalPresented) {
            isPresentedSelectionView = state.isModalPresented
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("프로필 위젯")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("닫기") {
                    isPresentedSelectionView = false
                }
                .typography(.medium_16)
            }
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationStack {
        WidgetSelectionView(isPresented: .constant(true))
    }
}
