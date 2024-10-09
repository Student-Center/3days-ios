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
    
    @StateObject var container: MVIContainer<AuthPhoneInputIntent.Intentable, AuthPhoneInputModel.Stateful>
    
    private var intent: AuthPhoneInputIntent.Intentable { container.intent }
    private var state: AuthPhoneInputModel.Stateful { container.model }
    
    public init() {
        let model = AuthPhoneInputModel()
        let intent = AuthPhoneInputIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthPhoneInputIntent.Intentable,
            model: model as AuthPhoneInputModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            LeftAlignText("전화번호를 입력해주세요")
                .typography(.semibold_24)
                .padding(.horizontal, 26)
            
            PhoneTextInputView(
                phoneTextInput: $container.model.phoneInputText,
                isPhoneValidated: state.isPhoneValidated
            )
            .onChange(of: state.phoneInputText) {
                intent.onChangePhoneInput(phone: state.phoneInputText)
            }
            .padding(.horizontal, 26)
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                isActive: state.isPhoneValidated
            ) {
                intent.onTapNextButton(with: state.phoneInputText)
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .padding(.top, 14)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

private struct PhoneTextInputView: View {
    @Binding var phoneTextInput: String
    let isPhoneValidated: Bool
    
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
    }
}

#Preview {
    NavigationView {
        AuthPhoneInputView()
    }
}
