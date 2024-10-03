//
//  AuthGreetingView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import DesignCore

public struct AuthGreetingView: View {
    @State var isAppeared = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("만나서 반가워요!\n당신이 어떤 사람인지 알려주세요.")
                .typography(.semibold_24)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignCore.Colors.grey500)
                .opacity(isAppeared ? 1.0 : 0.0)
                .offset(y: isAppeared ? 0 : -24)
            
            Spacer()
            
            CTAButton(title: "알려주러 가기") {
                AppCoordinator.shared.push(
                    .signUp(.authProfileGender)
                )
            }
            .padding(.horizontal, 24)
            .opacity(isAppeared ? 1.0 : 0.0)
            .offset(y: isAppeared ? 0 : -24)
            
            Spacer()
        }
        .setNavigation(
            showLeftBackButton: false,
            handler: {}
        )
        .ignoresSafeArea()
        .padding(.top, 155)
        .textureBackground()
        .task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.easeInOut(duration: 0.6)) {
                isAppeared = true
            }
        }
    }
}

#Preview {
    AuthGreetingView()
}
