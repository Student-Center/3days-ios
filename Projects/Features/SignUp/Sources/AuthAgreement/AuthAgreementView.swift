//
//  AuthAgreementView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthAgreementView: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 30) {
            LeftAlignText("인증이 완료되었어요!\n이용약관에 동의하면 끝나요")
                .typography(.semibold_24)
                .padding(.horizontal, 26)
            
            Text("TBD")
                .typography(.semibold_24)
                .foregroundStyle(DesignCore.Colors.grey200)
            
            Spacer()
            
            CTABottomButton(title: "다음") {
                AppCoordinator.shared.push(
                    .signUp(.authGreeting)
                )
            }
        }
        .ignoresSafeArea(.all)
        .padding(.top, 14)
        .textureBackground()
        .setNavigation {
            AppCoordinator.shared.pop()
        }
    }
}

#Preview {
    NavigationView {
        AuthAgreementView()
    }
}
