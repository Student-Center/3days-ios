//
//  DesignTextInputPreview.swift
//  DesignPreview
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import CoreKit

struct DesignTextInputPreview: View {
    @State var companyTextInput = String()
    @State var naverTextInput = String()
    
    @State var phoneTextInput = String()
    @State var isPhoneValidated = false
    
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
        ZStack {
            DesignCore.Colors.background
            VStack(spacing: 36) {
                TextInput(
                    placeholder: "내 회사 검색 혹은 직접 입력",
                    backgroundColor: .white,
                    text: $companyTextInput,
                    rightIcon: .init(
                        icon: DesignCore.Images.checkBold.image,
                        backgroundColor: Color(hex: 0x2DE76B)
                    )
                )
                
                TextInput(
                    placeholder: "검색어를 입력하세요",
                    backgroundColor: .white,
                    text: $naverTextInput,
                    rightIcon: .init(
                        icon: DesignCore.Images.search.image,
                        backgroundColor: DesignCore.Colors.grey100
                    )
                )
                
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
                    print(phoneTextInput)
                    let editedPhone = phoneTextInput.formattedPhoneNumber()
                    phoneTextInput = editedPhone
                    isPhoneValidated = editedPhone.isValidPhoneNumber()
                }
                
                Text(isPhoneValidated ? "전화번호 검증 완료" : "전화번호 검증 실패")
                    .typography(.medium_16)
            }
            .padding(.horizontal, 36)
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
        }
        .ignoresSafeArea(.container)
        .navigationTitle("Text Input")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DesignTextInputPreview()
    }
}
