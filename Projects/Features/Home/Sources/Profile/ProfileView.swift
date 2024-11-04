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
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 36)
                }
            } else {
                ProgressView()
            }
        }
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
        HomeMainView()
    }
}
