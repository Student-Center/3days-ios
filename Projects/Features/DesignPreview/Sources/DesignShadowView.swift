//
//  DesignShadowView.swift
//  DesignPreview
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignShadowView: View {
    var body: some View {
        ZStack {
            DesignCore.Colors.grey100
            
            HStack(spacing: 36) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.white)
                        .shadow(.default)
                    Text("Default")
                        .typography(.semibold_20)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.white)
                        .shadow(.alert)
                    Text("Alert")
                        .typography(.semibold_20)
                        .foregroundStyle(DesignCore.Colors.red300)
                }
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Shadow")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    DesignShadowView()
}
