//
//  Color+Ext.swift
//  CoreKit
//
//  Created by 김지수 on 11/11/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

extension Color {
    public init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
