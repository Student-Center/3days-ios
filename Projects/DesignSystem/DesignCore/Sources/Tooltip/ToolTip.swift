//
//  TooltipView.swift
//  ComponentsKit
//
//  Created by 김지수 on 9/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

extension View {
    public func tooltip(message: String, offset: CGFloat) -> some View {
        return modifier(ToolTipViewModifier(message: message, offset: offset))
    }
}

struct ToolTipViewModifier: ViewModifier {
    let message: String
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Text(message)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .typography(.regular_12)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(DesignCore.Colors.grey400)
                            VStack {
                                Spacer()
                                InvertedTriangle()
                            }
                            .offset(y: 12)
                        }
                    }
                    .frame(width: 300)
                    .offset(y: -offset)
            }
    }
}

fileprivate struct InvertedTriangle: View {
    let color: Color = DesignCore.Colors.grey400
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width / 2, y: height))
                path.closeSubpath()
            }
            .fill(color)
        }
        .frame(width: 16, height: 12)
    }
}
