//
//  CTABorderButton.swift
//  DesignCore
//
//  Created by 김지수 on 9/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct CTABorderButton<BackgroundStyle: ShapeStyle>: View {
    private let title: String
    private let backgroundStyle: BackgroundStyle
    private let titleColor: Color = .white
    private let isActive: Bool
    private var handler: () -> Void
    @Binding public var isShowLetter: Bool
    
    public init(
        title: String,
        backgroundStyle: BackgroundStyle = DesignCore.Colors.grey500,
        isActive: Bool = true,
        isShowLetter: Binding<Bool> = .constant(false),
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundStyle = backgroundStyle
        self.isActive = isActive
        self._isShowLetter = isShowLetter
        self.handler = handler
    }
    
    private var buttonBackgroundColor: BackgroundStyle {
        if !isActive {
            return DesignCore.Colors.grey100 as! BackgroundStyle
        }
        return backgroundStyle
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Capsule()
                .foregroundStyle(.white)
            Button(action: {
                handler()
            }, label: {
                VStack(spacing: 0) {
                    ZStack {
                        Capsule()
                            .foregroundStyle(buttonBackgroundColor)
                        Text(title)
                            .foregroundStyle(titleColor)
                            .typography(.semibold_18)
                    }
                }
            })
            .disabled(!isActive)
            .padding(.all, 5)
            
            DesignCore.Images.heartLetter.image
                .offset(x: -5, y: isShowLetter ? -18 : -28)
                .opacity(isShowLetter ? 1 : 0)
        }
        .shadow(.default)
    }
    
    func showLetterWithAnimated() {
        withAnimation {
            isShowLetter = true
        }
    }
}


#Preview {
    CTABorderButton(
        title: "수락할께요",
        backgroundStyle: LinearGradient.gradientA,
        isActive: true
    ) {
        
    }
    .frame(width: 164, height: 70)
}
