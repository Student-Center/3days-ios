//
//  ProfileView.swift
//  DesignPreview
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct ProfileView: View {
    
    @StateObject var container: MVIContainer<ProfileIntent.Intentable, ProfileModel.Stateful>
    
    private var intent: ProfileIntent.Intentable { container.intent }
    private var state: ProfileModel.Stateful { container.model }
    
    private var widgetSize: CGFloat {
        (Device.width - 36 - 12) / 2
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init() {
        let model = ProfileModel()
        let intent = ProfileIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as ProfileIntent.Intentable,
            model: model as ProfileModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            if let userInfo = state.userInfoModel {
                ScrollView {
                    VStack(spacing: 0) {
                        LeftAlignText("Date Profile")
                            .typography(.en_medium_20)
                        
                        DateProfilePanelView(
                            partnerInfo: userInfo.dreamPartner
                        ) { tab in
                            intent.onTapModifyDatePartnerProfile(tab)
                        }
                        .padding(.vertical, 20)
                        
                        LeftAlignText("My Profile")
                            .typography(.en_medium_20)
                        
                        ProfilePannelView(
                            name: userInfo.name,
                            profile: userInfo.profile
                        )
                        
                        LeftAlignText("Introductions")
                            .typography(.en_medium_16)
                            .padding(.bottom, 14)
                            .padding(.bottom, 16)
                            .foregroundStyle(Color(hex: 0x5E5E5E))
                        
                        // 비어있을 때의 뷰
                        if userInfo.profileWidgets.isEmpty {
                            ZStack {
                                Capsule()
                                    .inset(by: 1)
                                    .stroke(DesignCore.Colors.blue300, lineWidth: 1)
                                    .fill(Color(hex: 0xF2F9FF))
                                LeftAlignText("프로필 위젯을 추가해 나를 더 소개해보세요!🙌")
                                    .padding(.leading, 26)
                                    .typography(.semibold_14)
                                    .foregroundStyle(DesignCore.Colors.blue300)
                            }
                            .frame(height: 57)
                            .shadow(.default)
                            .padding(.bottom, 14)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.white)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(DesignCore.Colors.grey50)
                                    .strokeBorder(
                                        style: StrokeStyle(
                                            lineWidth: 3,
                                            dash: [8, 8]
                                        )
                                    )
                                    .foregroundStyle(Color(hex: 0xE0DEDD))
                                    .padding(.all, 8)
                                
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("프로필 위젯 추가하기")
                                        .typography(.semibold_14)
                                }
                                .foregroundStyle(DesignCore.Colors.grey200)
                            }
                            .frame(height: widgetSize)
                            .shadow(.default)
                            .padding(.bottom, 36)
                            .onTapGesture {
                                intent.onTapAddWidget()
                            }
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(userInfo.profileWidgets, id: \.widgetType.toDto) { widget in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(.white)
                                        ProfileWidgetView(
                                            title: widget.widgetType.title + widget.widgetType.emoji,
                                            bodyText: widget.content,
                                            titleColor: widget.widgetType.titleColor,
                                            bodyColor: widget.widgetType.bodyColor,
                                            gradientColors: widget.widgetType.gradationColors,
                                            iconType: .edit
                                        )
                                        .padding(.all, 4)
                                    }
                                    .frame(minHeight: widgetSize)
                                    .shadow(.default)
                                    .contextMenu {
                                        Button(action: {
                                            intent.onTapModifyWidget(widget)
                                        }) {
                                            Text("수정하기")
                                        }
                                        
                                        Button(
                                            role: .destructive,
                                            action: {
                                                intent.onTapDeleteWidget(widget)
                                        }) {
                                            Text("삭제하기")
                                        }
                                    }
                                }
                                let isEveryWidgetAdded = WidgetType.allCases.count == userInfo.profileWidgets.count
                                if !isEveryWidgetAdded {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(.white)
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(DesignCore.Colors.grey50)
                                            .strokeBorder(
                                                style: StrokeStyle(
                                                    lineWidth: 3,
                                                    dash: [8, 8]
                                                )
                                            )
                                            .foregroundStyle(Color(hex: 0xE0DEDD))
                                            .padding(.all, 8)
                                        
                                        VStack {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            Text("프로필 위젯\n추가하기")
                                                .typography(.semibold_14)
                                        }
                                        .foregroundStyle(DesignCore.Colors.grey200)
                                        .frame(minHeight: widgetSize)
                                    }
                                    .shadow(.default)
                                    .onTapGesture {
                                        intent.onTapAddWidget()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 36)
                    .padding(.bottom, 20)
                }
            } else {
                ProgressView()
            }
        }
        .sheet(
            isPresented: $container.model.isPresentedAddWidgetModal,
            content: {
                NavigationStack {
                    WidgetSelectionView(
                        isPresented: $container.model.isPresentedAddWidgetModal,
                        successHandler: {
                            Task {
                                await intent.refreshUserInfo()
                                try await Task.sleep(for: .seconds(1))
                                ToastHelper.show("위젯이 추가되었어요")
                            }
                        }
                    )
                }
        })
        .sheet(
            isPresented: $container.model.isPresentedModifyWidgetView,
            content: {
                if let widget = state.selectedWidgetType {
                    NavigationStack {
                        WidgetWritingView(
                            widgetType: widget.widgetType,
                            isModalPresented: $container.model.isPresentedModifyWidgetView,
                            isPushed: .constant(false),
                            isEditing: true,
                            contentString: widget.content,
                            successHandler: {
                                Task {
                                    await intent.refreshUserInfo()
                                    try await Task.sleep(for: .seconds(1))
                                    ToastHelper.show("위젯이 수정되었어요")
                                }
                            }
                        )
                    }
                }
            }
        )
        .sheet(
            isPresented: $container.model.isPresentedDeleteConfirmSheet,
            content: {
                if let widget = state.selectedWidgetType {
                    DeleteWidgetConfirmView {
                        Task {
                            await MainActor.run {
                                container.model.isPresentedDeleteConfirmSheet = false
                            }
                            await intent.deleteWidget(widget)
                        }
                    } cancelHandler: {
                        container.model.isPresentedDeleteConfirmSheet = false
                    }
                    .presentationDetents([.height(280)])
                    .presentationCornerRadius(20)
                }
            }
        )
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setLoading(state.isLoading)
    }
}

fileprivate struct DeleteWidgetConfirmView: View {
    let confirmHandler: () -> Void
    let cancelHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                LeftAlignText("위젯을 삭제하시겠어요?")
                    .typography(.semibold_20)
                    .foregroundStyle(Color(hex: 0x454545))
                LeftAlignText("삭제된 위젯은 복구할 수 없어요.")
                    .typography(.regular_14)
                    .foregroundStyle(DesignCore.Colors.grey200)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                CTAButton(
                    title: "네, 삭제할게요",
                    titleColor: .white,
                    backgroundStyle: DesignCore.Colors.red300
                ) {
                    confirmHandler()
                }
                CTAButton(
                    title: "아니요",
                    titleColor: DesignCore.Colors.grey400,
                    backgroundStyle: Color(hex: 0xF2F1F1)
                ) {
                    cancelHandler()
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 30)
    }
}

#Preview(body: {
    HomeMainView(userInfo: .mock)
})
