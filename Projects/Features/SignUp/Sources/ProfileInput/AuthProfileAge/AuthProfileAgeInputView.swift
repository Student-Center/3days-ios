//
//  AuthProfileAgeView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import CommonKit

public struct AuthProfileAgeInputView: View {
    
    @State var birthYear = String()
    @State var errorMessage: String? = "잘못 입력하셨어요"
    @FocusState var isFocused
    
    public init() {}
    
    var targetGender: String {
        let tempTarget = "여성"
        return tempTarget
    }
    
    public var body: some View {
        VStack {
            ProfileInputTemplatedView(
                currentPage: 2,
                maxPage: 5,
                subMessage: "좋은 \(targetGender) 소개시켜 드릴께요!",
                mainMessage: "당신의 나이는 무엇인가요?"
            ) {
                VStack {
                    HStack {
                        VerifyCodeInputView(
                            verifyCode: $birthYear,
                            errorMessage: $errorMessage,
                            verifyCodeMaxCount: 4,
                            boxHeight: 92,
                            textColor: .black,
                            borderWidth: 4,
                            borderColor: .white,
                            backColor: DesignCore.Colors.yellow50,
                            cornerRadius: 20,
                            focused: _isFocused
                        )
                        .padding(.horizontal, 6)
                        
                        VStack {
                            Spacer()
                            Text("년생")
                                .typography(.semibold_18)
                                .foregroundStyle(DesignCore.Colors.grey300)
                        }
                    }
                    .frame(height: 92)
                    
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 4) {
                            DesignCore.Images.iconInformation.image
                            Text("가입 연령 확인하기")
                                .typography(.regular_14)
                                .foregroundStyle(DesignCore.Colors.grey200)
                        }
                    })
                    .padding(.top, 20)
                }
                .padding(.top, 8)
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                isActive: birthYear.count > 3
            ) {
                // TODO: 순서 재정의
                AppCoordinator.shared.push(.signUp(.authName))
            }
        }
        .ignoresSafeArea()
        .padding(.top, 10)
        .textureBackground()
        .setNavigation(showLeftBackButton: false) {
            
        }
    }
}

#Preview {
    NavigationView {
        AuthProfileAgeInputView()
    }
}
