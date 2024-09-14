//
//  Typography.swift
//  DesignCore
//
//  Created by 김지수 on 9/14/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI

public enum Typography {
    // EN - Medium
    case en_medium_20
    case en_medium_16
    
    // Pretendard - semibold
    case semibold_28
    case semibold_24
    case semibold_20
    case semibold_14
    
    // Pretendard - medium
    case medium_18
    case medium_16
    case medium_14
    
    // Pretendard - regular
    case regular_15
    case regular_14
    case regular_12
}

extension Typography {
    var fontSize: CGFloat {
        switch self {
        case .en_medium_20: return 20
        case .en_medium_16: return 16
        case .semibold_28: return 28
        case .semibold_24: return 24
        case .semibold_20: return 20
        case .semibold_14: return 14
        case .medium_18: return 18
        case .medium_16: return 16
        case .medium_14: return 14
        case .regular_15: return 15
        case .regular_14: return 14
        case .regular_12: return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .en_medium_20: return 20
        case .en_medium_16: return 16
        default: return fontSize * 1.5
        }
    }
}

extension Typography {
    var pretendardWeight: PretendardWeight? {
        switch self {
        case .en_medium_20, .en_medium_16:
            return nil
            
        case .semibold_28, .semibold_24, .semibold_20, .semibold_14:
            return ._600
            
        case .medium_18, .medium_16, .medium_14:
            return ._500
            
        case .regular_15, .regular_14, .regular_12:
            return ._400
        }
    }
}

private struct TypographyViewModifier: ViewModifier {
    let typography: Typography
    
    func body(content: Content) -> some View {
        switch typography {
        case .en_medium_16, .en_medium_20:
            content
                .robotoSlab(
                    size: typography.fontSize,
                    lineHeight: typography.lineHeight
                )
        default:
            content
                .pretendard(
                    weight: typography.pretendardWeight!,
                    size: typography.fontSize,
                    lineHeight: typography.lineHeight
                )
        }
    }
}

public extension View {
    func typography(_ typograpy: Typography) -> some View {
        return modifier(
            TypographyViewModifier(typography: typograpy)
        )
    }
}
