//
//  CTABottomButton.swift
//  ComponentsKit
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import Combine

public struct CTABottomButton: View {
    private let title: String
    private let backgroundStyle: AnyShapeStyle
    private let titleColor: Color = .white
    private let isActive: Bool
    private var handler: () -> Void
    
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var keyboardHeight: CGFloat = 0
    @State private var maxKeyboardHeight: CGFloat = 0

    public init(
        title: String,
        backgroundStyle: some ShapeStyle = DesignCore.Colors.grey500,
        isActive: Bool = true,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundStyle = AnyShapeStyle(backgroundStyle)
        self.isActive = isActive
        self.handler = handler
    }

    private var buttonBackgroundColor: AnyShapeStyle {
        if !isActive {
            return AnyShapeStyle(DesignCore.Colors.grey100)
        }
        return backgroundStyle
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    handler()
                }, label: {
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(buttonBackgroundColor)
                                .frame(height: 68)
                                .cornerRadius(
                                    20,
                                    corners: [.topLeft, .topRight]
                                )
                            Text(title)
                                .foregroundStyle(titleColor)
                                .typography(.semibold_18)
                        }
                        Rectangle()
                            .foregroundStyle(buttonBackgroundColor)
                            .frame(height: max(Device.bottomInset, keyboardHeight))
                    }
                })
                .disabled(!isActive)
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(y: -min(keyboardHeight, geometry.safeAreaInsets.bottom))
            .animation(.snappy(duration: 0.35), value: keyboardHeight)
        }
        .onAppear {
            Publishers.Merge(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                    .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                    .map { $0.height },
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in CGFloat(0) }
            )
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        }
        .onDisappear {
            cancellables.removeAll()
        }
    }
}
