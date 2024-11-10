//
//  ProfileWidgetView.swift
//  DesignCore
//
//  Created by 김지수 on 11/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

struct ProfileWidgetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            .init(hex: 0xEDF7FF),
                            .init(hex: 0xCDE8FF),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                VStack {
                    HStack {
                        Text("취미")
                        Spacer()
                        Image(systemName: "plus.circle")
                    }
                    Spacer()
                    ScrollView {
                    LeftAlignText(
                    """
                    ex.
                    공백 포함해서 최소 5글자 이상부터 최대 40자까지 입력
                    우어어어엉
                    """
                    )
                    .typography(.regular_14)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.all, 20)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
            ProfileWidgetView()
                .frame(width: 162, height: 150)
        }
    }

}
