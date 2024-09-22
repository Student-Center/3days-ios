//
//  DesignToolTipView.swift
//  DesignPreview
//
//  Created by 김지수 on 9/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignToolTipView: View {
    var body: some View {
        ZStack {
            DesignCore.Colors.background
            
            VStack(spacing: 60) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 100)
                    .tooltip(
                        message: "현재 상대와 만난 시간을 볼 수 있어요!",
                        offset: 100
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 100)
                    .tooltip(
                        message: "매칭된 상대의 프로필을 볼 수 있어요👀\n미공개 프로필은 날짜에 따라 업데이트 돼요.",
                        offset: 100
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 100)
                    .tooltip(
                        message: "1일차 시작! 큐피드 WEAVY🧚와 함께\n매칭된 상대와의 채팅에서 서로를 알아가요.\n외모췍!!",
                        offset: 100
                    )
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Tooltip")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DesignToolTipView()
}
