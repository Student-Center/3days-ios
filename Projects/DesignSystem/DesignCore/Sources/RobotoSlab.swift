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
    
    func body(content: Content) -> some View {
        content
            .font(.robotoSlab(size: size))
    }
}

public extension View {
    func robotoSlab(size: CGFloat) -> some View {
        return modifier(RobotoSlabModifier(size: size))
    }
}
