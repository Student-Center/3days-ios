//
//  RobotoSlab.swift
//  DesignCore
//
//  Created by 김지수 on 9/14/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI
import UIKit

public extension Font {
    static func robotoSlab(size: CGFloat) -> Font {
        return DesignCoreFontFamily.RobotoSlab.medium.font(size: size)
    }
}

public extension UIFont {
    static func robotoSlab(size: CGFloat) -> UIFont {
        return .init(font: DesignCoreFontFamily.RobotoSlab.medium, size: size)!
    }
}

private struct RobotoSlabModifier: ViewModifier {
    let size: CGFloat
    var lineHeight: CGFloat? = nil
    
    func body(content: Content) -> some View {
        if let lineHeight {
            let uifont = UIFont.robotoSlab(size: size)
            content
                .font(Font(uiFont: uifont))
                .lineSpacing(lineHeight - uifont.lineHeight)
                .padding(.vertical, (lineHeight - uifont.lineHeight))
        } else {
            content
                .font(.robotoSlab(size: size))
        }
    }
}

public extension View {
    func robotoSlab(
        size: CGFloat,
        lineHeight: CGFloat? = nil
    ) -> some View {
        return modifier(
            RobotoSlabModifier(
                size: size,
                lineHeight: lineHeight
            )
        )
    }
}
