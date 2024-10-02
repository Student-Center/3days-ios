//
//  AuthNameInputView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import CommonKit
import UIKit

public struct AuthNameInputView: View {
    
    @State var inputText = String()
    
    public init() {

    }
    
    @ViewBuilder
    var backgroundView: some View {
        ZStack {
            DesignCore.Images.namePaper.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 72)
            DesignCore.Images.pencil.image
                .resizable()
                .frame(width: 68, height: 68)
                .offset(x: 100, y: 12)
        }
    }

    public var body: some View {
        VStack(spacing: 44) {
            VStack(spacing: 0) {
                Text("이제 마지막이에요.")
                    .typography(.regular_14)
                    .foregroundStyle(DesignCore.Colors.grey200)
                Text("당신의 이름은 무엇인가요?")
                    .typography(.semibold_24)
                    .foregroundStyle(DesignCore.Colors.grey500)
            }
            
            ZStack {
                backgroundView
                TextField(
                    "김위브",
                    text: $inputText
                )
                .keyboardType(.namePhonePad)
                .interactiveDismissDisabled()
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .speechAnnouncementsQueued(false)
                .speechSpellsOutCharacters(false)
                .multilineTextAlignment(.center)
                .pretendard(weight: ._400, size: 28)
                .foregroundStyle(DesignCore.Colors.grey500)
                .offset(y: -4)
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                backgroundStyle: LinearGradient.gradientA,
                isActive: inputText.count >= 2
            ) {
                
            }
        }
        .ignoresSafeArea()
        .padding(.top, 10)
        .textureBackground()
        .setNavigation {
            AppCoordinator.shared.pop()
        }
    }
}

#Preview {
    NavigationView {
        AuthNameInputView()
    }
}
