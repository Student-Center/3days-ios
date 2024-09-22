//
//  DesignToastView.swift
//  DesignPreview
//
//  Created by 김지수 on 9/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignToastView: View {
    @State var isPresent = false
    
    var body: some View {
        ZStack {
            DesignCore.Colors.background
            CTAButton(title: "Show Toast") {
                isPresent.toggle()
            }
            .padding(.horizontal, 36)
        }
        .toast(
            message: "나이를 입력해주세요",
            isPresent: $isPresent
        )
        .ignoresSafeArea()
        .navigationTitle("Toast")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DesignToastView()
}
