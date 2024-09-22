//
//  DesignColorPreview.swift
//  DesignPreview
//
//  Created by 김지수 on 9/17/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignColorPreview: View {
    
    let blackColors = [
        DesignCore.Colors.black,
        DesignCore.Colors.grey500,
        DesignCore.Colors.grey400,
        DesignCore.Colors.grey300,
        DesignCore.Colors.grey200,
        DesignCore.Colors.grey100
    ]
    
    let tintColors = [
        DesignCore.Colors.red300,
        DesignCore.Colors.blue300
    ]
    
    let lightColors = [
        DesignCore.Colors.green500,
        DesignCore.Colors.pink500,
        DesignCore.Colors.blue500,
        DesignCore.Colors.green100,
        DesignCore.Colors.pink100
    ]
    
    let pastelColors = [
        DesignCore.Colors.yellow50,
        DesignCore.Colors.green50,
        DesignCore.Colors.pink50,
        DesignCore.Colors.blue50,
    ]
    
    var colorGroups: [[Color]] {
        return [
            blackColors,
            tintColors,
            lightColors,
            pastelColors
        ]
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(colorGroups, id: \.self) { group in
                HStack {
                    ForEach(group, id: \.self) {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 36, height: 36)
                            .foregroundStyle($0)
                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 60)
                .padding(.horizontal, 36)
                .foregroundStyle(LinearGradient.gradientA)
        }
        .navigationTitle("Color System")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    DesignColorPreview()
}
