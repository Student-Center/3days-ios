//
//  DesignTextInputPreview.swift
//  DesignPreview
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignTextInputPreview: View {
    @State var companyTextInput = String()
    @State var naverTextInput = String()
    
    var body: some View {
        ZStack {
            DesignCore.Colors.background
            VStack(spacing: 36) {
                TextInput(
                    placeholder: "내 회사 검색 혹은 직접 입력",
                    backgroundColor: .white,
                    text: $companyTextInput,
                    rightIcon: .init(
                        icon: DesignCore.Images.checkBold.image!,
                        backgroundColor: Color(hex: 0x2DE76B)
                    )
                )
                
                TextInput(
                    placeholder: "검색어를 입력하세요",
                    backgroundColor: .white,
                    text: $companyTextInput,
                    rightIcon: .init(
                        icon: DesignCore.Images.search.image!,
                        backgroundColor: DesignCore.Colors.grey100
                    )
                )
            }
            .padding(.horizontal, 36)
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
