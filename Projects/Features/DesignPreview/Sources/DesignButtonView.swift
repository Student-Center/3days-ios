//
//  DesignButtonView.swift
//  DesignPreview
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignButtonView: View {
    
    @FocusState var isTextFieldFocused
    @State var text = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            TextField("Placeholder", text: $text)
                .focused($isTextFieldFocused)
            CTAButton(
                title: "타이틀",
                backgroundStyle: DesignCore.Colors.blue300
            ) {}
            .padding(.horizontal, 36)
            
            CTAButton(
                title: "타이틀",
                backgroundStyle: DesignCore.Colors.green500
            ) {}
            .padding(.horizontal, 36)
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                backgroundStyle: LinearGradient.gradientA,
                isActive: true,
                keyboardShown: isTextFieldFocused
            ) {
                if isTextFieldFocused {
                    isTextFieldFocused.toggle()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle("CTA Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DesignButtonView()
}
