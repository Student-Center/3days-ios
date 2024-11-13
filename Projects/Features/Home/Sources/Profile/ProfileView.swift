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
    @State var isPresentWidgetSelectionView = false
    
    private var intent: ProfileIntent.Intentable { container.intent }
    private var state: ProfileModel.Stateful { container.model }
    
    private var widgetSize: CGFloat {
        (Device.width - 36 - 12) / 2
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init(userInfo: UserInfo) {
        let model = ProfileModel()
        let intent = ProfileIntent(
            model: model,
            input: .init(
                userInfo: userInfo
            )
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
                                isPresentWidgetSelectionView = true
                            }
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(userInfo.profileWidgets, id: \.self) { widget in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(.white)
                                        ProfileWidgetView(
                                            title: widget.widgetType.title,
                                            bodyText: widget.content,
                                            titleColor: widget.widgetType.titleColor,
                                            bodyColor: widget.widgetType.bodyColor,
                                            gradientColors: widget.widgetType.gradationColors
                                        )
                                        .padding(.all, 4)
                                    }
                                    .shadow(.default)
                                    .onTapGesture {

                                    }
                                }
                                
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
                                .shadow(.default)
                                .onTapGesture {
                                    isPresentWidgetSelectionView = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 36)
                }
            } else {
                ProgressView()
            }
        }
        .sheet(
            isPresented: $isPresentWidgetSelectionView,
            content: {
                NavigationStack {
                    WidgetSelectionView(
                        isPresented: $isPresentWidgetSelectionView
                    )
                }
        })
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        HomeMainView(userInfo: .mock)
    }
}
