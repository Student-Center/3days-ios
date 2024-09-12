//
//  Pretendard.swift
//  DesignCore
//
//  Created by 김지수 on 9/13/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI
import UIKit

public enum PretendardWeight {
    case _100
    case _200
    case _300
    case _400
    case _500
    case _600
    case _700
    case _800
    case _900
    
    public var font: DesignCoreFontConvertible {
        switch self {
        case ._100:
            return DesignCoreFontFamily.Pretendard.thin
        case ._200:
            return DesignCoreFontFamily.Pretendard.extraLight
        case ._300:
            return DesignCoreFontFamily.Pretendard.light
        case ._400:
            return DesignCoreFontFamily.Pretendard.regular
        case ._500:
            return DesignCoreFontFamily.Pretendard.medium
        case ._600:
            return DesignCoreFontFamily.Pretendard.semiBold
        case ._700:
            return DesignCoreFontFamily.Pretendard.bold
        case ._800:
            return DesignCoreFontFamily.Pretendard.extraBold
        case ._900:
            return DesignCoreFontFamily.Pretendard.black
        }
    }
}

public extension Font {
    static func pretendard(_ weight: PretendardWeight, size: CGFloat) -> Font {
        return weight.font.font(size: size)
    }
}

public extension UIFont {
    static func pretendard(_ weight: PretendardWeight, size: CGFloat) -> UIFont {
        return .init(font: weight.font, size: size)!
    }
}

private struct PretendardModifier: ViewModifier {
    let weight: PretendardWeight
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.pretendard(weight, size: size))
    }
}

public extension View {
    func pretendard(weight: PretendardWeight, size: CGFloat) -> some View {
        return modifier(PretendardModifier(weight: weight, size: size))
    }
}
