//
//  AuthPhoneInputView.swift
//  SignUp
//
//  Created by 김지수 on 9/30/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthPhoneInputView: View {
    
    @State var phoneTextInput = String()
    @State var isPhoneValidated = false
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            LeftAlignText("전화번호를 입력해주세요")
                .typography(.semibold_24)
                .padding(.horizontal, 26)
            
            PhoneTextInputView(
                phoneTextInput: $phoneTextInput,
                isPhoneValidated: $isPhoneValidated
            )
            .padding(.horizontal, 26)
            
            Spacer()
            
            CTABottomButton(title: "다음", isActive: isPhoneValidated) {
                AppCoordinator.shared.push(
                    .signUp(
                        .authPhoneVerify
                    )
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

private struct PhoneTextInputView: View {
    @Binding var phoneTextInput: String
    @Binding var isPhoneValidated: Bool
    
    var phoneRightIcon: TextInputRightIconModel? {
        if isPhoneValidated {
            return .init(
                icon: DesignCore.Images.checkBold.image,
                backgroundColor: Color(hex: 0x2DE76B)
            )
        }
        return nil
    }
    
    var body: some View {
        TextInput(
            placeholder: "전화번호를 입력하세요",
            backgroundColor: .white,
            text: $phoneTextInput,
            keyboardType: .phonePad,
            leftView: {
                HStack(spacing: 6) {
                    DesignCore.Images.flagKorea.image
                    Text("+82")
                        .foregroundStyle(DesignCore.Colors.grey200)
                        .typography(.medium_16)
                    Rectangle()
                        .frame(
                            width: 1,
                            height: 11
                        )
                        .foregroundStyle(Color(hex: 0xE8E6E4))
                }
            },
            rightIcon: phoneRightIcon
        )
        .onChange(of: phoneTextInput) {
            let editedPhone = phoneTextInput.formattedPhoneNumber()
            phoneTextInput = editedPhone
            isPhoneValidated = editedPhone.isValidPhoneNumber()
        }
    }
}

#Preview {
    NavigationView {
        AuthPhoneInputView()
    }
}
