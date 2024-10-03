//
//  ProfileInputTemplatedView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct ProfileInputTemplatedView<ContentView: View>: View {
    
    let currentPage: Int
    let maxPage: Int
    let subMessage: String
    let mainMessage: String
    @ViewBuilder var contentView: () -> ContentView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Text("\(currentPage)")
                    .foregroundStyle(DesignCore.Colors.blue300)
                Text("/\(maxPage)")
                    .foregroundStyle(DesignCore.Colors.grey300)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background {
                Capsule()
                    .foregroundStyle(.white)
            }
            .typography(.regular_15)
            .padding(.horizontal, 26)
            
            VStack(spacing: 0) {
                LeftAlignText(subMessage)
                    .typography(.regular_14)
                    .foregroundStyle(DesignCore.Colors.grey200)
                LeftAlignText(mainMessage)
                    .typography(.semibold_24)
                    .foregroundStyle(DesignCore.Colors.grey500)
            }
            .padding(.horizontal, 26)
            
            contentView()
                .padding(.horizontal, 26)
        }
    }
}
