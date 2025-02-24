//
//  WidgetColorSet.swift
//  Chat
//
//  Created by 김지수 on 2/24/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import Model

struct WidgetColorSet {
    let gradientColors: [Color]
    let titleColor: Color
    let bodyColor: Color
    
    init(
        gradientColors: [Color],
        titleColor: Color
    ) {
        self.gradientColors = gradientColors
        self.titleColor = titleColor
        self.bodyColor = titleColor.opacity(0.6)
    }
    
    static var allColorSets: [WidgetColorSet] {
        [skyBlueColorSet, brownColorSet, pinkColorSet, greyColorSet, greenColorSet]
    }
    
    static var skyBlueColorSet: WidgetColorSet {
        .init(
            gradientColors: [
                .init(hex: 0xEDF7FF),
                .init(hex: 0xCDE8FF),
            ],
            titleColor: .init(hex: 0x15394B)
        )
    }
    
    static var brownColorSet: WidgetColorSet {
        .init(
            gradientColors: [
                .init(hex: 0xFAF3E5),
                .init(hex: 0xEEDCB9),
            ],
            titleColor: .init(hex: 0x4C3B1C)
        )
    }
    
    static var pinkColorSet: WidgetColorSet {
        .init(
            gradientColors: [
                .init(hex: 0xFEF0F4),
                .init(hex: 0xEFD6E1),
            ],
            titleColor: .init(hex: 0x6C324A)
        )
    }
    
    static var greyColorSet: WidgetColorSet {
        .init(
            gradientColors: [
                .init(hex: 0xF9F9F9),
                .init(hex: 0xE7E7E7),
            ],
            titleColor: .init(hex: 0x454545)
        )
    }
    
    static var greenColorSet: WidgetColorSet {
        .init(
            gradientColors: [
                .init(hex: 0xF2FCEB),
                .init(hex: 0xD7E9C8),
            ],
            titleColor: .init(hex: 0x1D5018)
        )
    }
}

extension WidgetType {
    private var colorSet: WidgetColorSet {
        let index = WidgetType.allCases.firstIndex(of: self) ?? 0
        let allColors = WidgetColorSet.allColorSets
        return allColors[index % allColors.count]
    }
    
    public var titleColor: Color {
        colorSet.titleColor
    }
    
    public var bodyColor: Color {
        colorSet.bodyColor
    }
    
    public var gradationColors: [Color] {
        colorSet.gradientColors
    }
}
