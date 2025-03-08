//
//  FlipUpsideDown.swift
//  DesignCore
//
//  Created by 김지수 on 3/8/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI

fileprivate struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
}

public extension View{
    func flippedUpsideDown() -> some View{
        self.modifier(FlippedUpsideDown())
    }
}
