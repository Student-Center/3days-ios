//
//  HomeMainView.swift
//  DesignPreview
//
//  Created by 김지수 on 11/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct HomeMainView: View {
    
    @StateObject var container: MVIContainer<HomeMainIntent.Intentable, HomeMainModel.Stateful>
    
    private var intent: HomeMainIntent.Intentable { container.intent }
    private var state: HomeMainModel.Stateful { container.model }
    
    public init(userInfo: UserInfo?) {
        let model = HomeMainModel()
        let intent = HomeMainIntent(
            model: model,
            input: .init(userInfo: userInfo)
        )
        let container = MVIContainer(
            intent: intent as HomeMainIntent.Intentable,
            model: model as HomeMainModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if let userInfo = state.userInfo {
                // Tab
                HStack(spacing: 30) {
                    ForEach(HomeMainTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                intent.onTapTab(tab)
                            }
                        }) {
                            VStack(spacing: 0) {
                                let isSelected = tab == state.selectedTab
                                Circle()
                                    .frame(width: 6, height: 6)
                                    .foregroundStyle(isSelected ? DesignCore.Colors.grey500 : .clear)
                                Text(tab.title)
                                    .typography(.en_medium_20)
                                    .padding(.vertical, 12)
                                    .foregroundColor(isSelected ? DesignCore.Colors.grey500 : DesignCore.Colors.grey500.opacity(0.2))
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                
                // 탭 콘텐츠
                TabView(selection: $container.model.selectedTab) {
                    // 첫 번째 탭 내용
                    VStack {
                        Text("첫 번째 탭")
                    }
                    .tag(HomeMainTab.home)
                    
                    // 두 번째 탭 내용
                    ProfileView(userInfo: userInfo)
                        .tag(HomeMainTab.profile)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .textureBackground()
        .toolbar(.hidden, for: .navigationBar)
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        HomeMainView(userInfo: .mock)
    }
}
