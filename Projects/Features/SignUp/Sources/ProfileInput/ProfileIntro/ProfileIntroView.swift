//
//  ProfileIntroView.swift
//  SignUp
//
//  Created by 김지수 on 11/20/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct ProfileIntroView: View {
    
    @StateObject var container: MVIContainer<ProfileIntroIntent.Intentable, ProfileIntroModel.Stateful>
    
    @State var isShowIcon: Bool = false
    @State var isShowText: Bool = false
    
    private var intent: ProfileIntroIntent.Intentable { container.intent }
    private var state: ProfileIntroModel.Stateful { container.model }
    
    public init(_ input: SignUpFormDomain) {
        let model = ProfileIntroModel()
        let intent = ProfileIntroIntent(
            model: model,
            input: .init(input: input)
        )
        let container = MVIContainer(
            intent: intent as ProfileIntroIntent.Intentable,
            model: model as ProfileIntroModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        .init(hex: 0xF3DDE5).opacity(0.0),
                        .init(hex: 0xF3DDE5)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: Device.height * 0.5)
            }
            
            VStack(spacing: 24) {
                DesignCore.Images.magnifyingGlass.image
                    .resizable()
                    .frame(width: 48, height: 48)
                    .opacity(isShowIcon ? 1 : 0)
                    .offset(y: isShowIcon ? -32 : 0)
                
                Text("만나서 반가워요!\n이제 당신이 어떤 사람인지 알려주세요.")
                    .typography(.semibold_20)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DesignCore.Colors.grey500)
                    .opacity(isShowText ? 1 : 0)
                    .offset(y: isShowText ? -32 : 0)
            }
            .animation(.easeInOut, value: isShowIcon)
            .animation(.easeInOut, value: isShowText)
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
        .task {
            await intent.task()
            try? await Task.sleep(for: .milliseconds(250))
            isShowIcon = true
            try? await Task.sleep(for: .milliseconds(150))
            isShowText = true
        }
        .onAppear {
            intent.onAppear()
        }
    }
}

#Preview {
    NavigationView {
        ProfileIntroView(.mock)
    }
}
