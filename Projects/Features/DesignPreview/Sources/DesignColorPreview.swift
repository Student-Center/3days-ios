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
        DesignCore.black,
        DesignCore.grey500,
        DesignCore.grey400,
        DesignCore.grey300,
        DesignCore.grey200,
        DesignCore.grey100
    ]
    
    let tintColors = [
        DesignCore.red300,
        DesignCore.blue300
    ]
    
    let pastelColors = [
        DesignCore.darkGreen,
        DesignCore.darkPink,
        DesignCore.darkBlue,
        DesignCore.lightYellow,
        DesignCore.lightGreen,
        DesignCore.lightPink,
        DesignCore.lightBlue,
    ]
    
    var colorGroups: [[Color]] {
        return [
            blackColors,
            tintColors,
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
