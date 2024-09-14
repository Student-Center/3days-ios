//
//  Font+Ext.swift
//  DesignSystemKit
//
//  Created by 김지수 on 9/13/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI
import UIKit

public extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}

extension DesignCoreFontConvertible {
    public func uiFont(size: CGFloat) -> UIFont {
        guard let uiFont = UIFont(font: self, size: size) else {
            fatalError("Unable to initialize font name: '\(name)', family: \(family)")
        }
        return uiFont
    }
    public func font(size: CGFloat) -> Font {
        guard let font = UIFont(font: self, size: size) else {
            fatalError("Unable to initialize font name: '\(name)', family: \(family)")
        }
        return Font(uiFont: font)
    }
}
