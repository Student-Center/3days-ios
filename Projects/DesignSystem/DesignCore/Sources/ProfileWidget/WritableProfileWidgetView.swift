//
//  WritableProfileWidgetView.swift
//  DesignCore
//
//  Created by 김지수 on 11/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct WritableProfileWidgetView: View {
    @FocusState private var isfocused: Bool
    @Binding public var bodyText: String
    public let title: String
    public let placeholder: String
    public let titleColor: Color
    public let bodyColor: Color
    public let gradientColors: [Color]
    
    public init(
        title: String,
        placeholder: String,
        bodyText: Binding<String>,
        titleColor: Color,
        bodyColor: Color,
        gradientColors: [Color],
        focusState: FocusState<Bool> = .init()
    ) {
        self.title = title
        self.placeholder = placeholder
        self._bodyText = bodyText
        self.titleColor = titleColor
        self.bodyColor = bodyColor
        self.gradientColors = gradientColors
        self._isfocused = focusState
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            VStack {
                HStack {
                    Text(title)
                        .pretendard(weight: ._600, size: 22)
                        .foregroundStyle(titleColor)
                    Spacer()
                }
                Spacer()
                ZStack(alignment: .topLeading) {
                    if bodyText.isEmpty {
                        Text(placeholder)
                            .typography(.regular_14)
                            .foregroundStyle(
                                Color(hex: 0x15394B4D).opacity(0.3)
                            )
                            .padding(.all, 8)
                    }
                    
                    TextEditor(
                        text: $bodyText
                    )
                    .textEditorStyle(
                        PlainTextEditorStyle()
                    )
                    .focused($isfocused)
                    .flatTextFieldOption()
                    .typography(.regular_14)
                    .foregroundStyle(bodyColor)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.all, 28)
        }
    }
}

struct PreviewView: View {
    @State var text = ""
    
    var body: some View {
        WritableProfileWidgetView(
            title: "Title",
            placeholder: "this is Placeholder hahaha dhdhdh 바래보아요",
            bodyText: $text,
            titleColor: .black,
            bodyColor: .red,
            gradientColors: [.yellow, .green]
        )
        .frame(width: 300, height: 300)
    }
}

#Preview {
    PreviewView()
}
