//
//  WritableProfileWidgetView.swift
//  DesignCore
//
//  Created by 김지수 on 11/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct WritableProfileWidgetView: View {
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
        gradientColors: [Color]
    ) {
        self.title = title
        self.placeholder = placeholder
        self._bodyText = bodyText
        self.titleColor = titleColor
        self.bodyColor = bodyColor
        self.gradientColors = gradientColors
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
                TextEditor(
                    text: $bodyText
                )
                .textEditorStyle(
                    PlainTextEditorStyle()
                )
                .typography(.regular_14)
                .foregroundStyle(bodyColor)
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
            placeholder: "Placeholder",
            bodyText: $text,
            titleColor: .black,
            bodyColor: .red,
            gradientColors: [.yellow, .green]
        )
        .frame(width: 200, height: 200)
    }
}

#Preview {
    PreviewView()
}
