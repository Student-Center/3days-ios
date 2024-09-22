//
//  ToastView.swift
//  ComponentsKit
//
//  Created by 김지수 on 9/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    let message: String
    @Binding var isPresented: Bool
    let bottomPadding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    VStack {
                        Spacer()
                        Toast(
                            message: message,
                            isPresent: $isPresented
                        )
                        .offset(y: -(bottomPadding + Device.bottomInset))
                    }
                }
            }
    }
}

extension View {
    public func toast(
        message: String,
        isPresent: Binding<Bool>,
        bottomPadding: CGFloat = 0
    ) -> some View {
        modifier(
            ToastViewModifier(
                message: message,
                isPresented: isPresent,
                bottomPadding: bottomPadding
            )
        )
    }
}

struct Toast: View {
    let message: String
    @Binding var isPresent: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .inset(by: 1)
                .stroke(
                    DesignCore.Colors.red300.opacity(0.5),
                    lineWidth: 1
                )
                .background(DesignCore.Colors.red300.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(.alert)
            
            HStack(spacing: 6) {
                DesignCore.Images.alert.image
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(message)
                    .typography(.medium_16)
                    .foregroundStyle(DesignCore.Colors.red300)
            }
        }
        .frame(height: 52)
        .padding(.horizontal, 28)
        .offset(y: isPresent ? 0 : 100)
        .opacity(isPresent ? 1 : 0)
        .animation(.bouncy(duration: 0.25), value: isPresent)
        .onChange(of: isPresent) {
            if isPresent {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isPresent = false
                }
            }
        }
    }
}
