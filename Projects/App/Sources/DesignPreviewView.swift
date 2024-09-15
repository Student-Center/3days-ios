//
//  DesignPreviewView.swift
//  App
//
//  Created by 김지수 on 9/14/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignPreviewView: View {
    
    let blackColors = [
        DesignCore.black,
        DesignCore.grey500,
        DesignCore.grey400,
        DesignCore.grey300,
        DesignCore.grey200,
        DesignCore.grey100
    ]
    
    let tintColors = [
        DesignCore.red300,
        DesignCore.blue300
    ]
    
    let pastelColors = [
        DesignCore.darkGreen,
        DesignCore.darkPink,
        DesignCore.darkBlue,
        DesignCore.lightYellow,
        DesignCore.lightGreen,
        DesignCore.lightPink,
        DesignCore.lightBlue,
    ]
    
    var colorGroups: [[Color]] {
        return [
            blackColors,
            tintColors,
            pastelColors
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        ForEach(colorGroups, id: \.self) { group in
                            HStack {
                                ForEach(group, id: \.self) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle($0)
                                }
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 36)
                            .padding(.horizontal, 36)
                            .foregroundStyle(LinearGradient.gradientA)
                    }
                    Divider()
                    
                    Text("HOME / en-medium-20")
                        .typography(.en_medium_20)
                        .foregroundStyle(DesignCore.black)
                    Text("Introduction / en-medium-16")
                        .typography(.en_medium_16)
                        .foregroundStyle(DesignCore.grey400)
                    Text("새 메시지 3개 / semibold-14")
                        .typography(.semibold_14)
                        .foregroundStyle(DesignCore.grey500)
                    Text("안녕하세요? 이것은 샘플 화면입니다...\nUI를 잡아보는 중인데 글자 수가 얼마... / regular-15")
                        .typography(.regular_15)
                        .foregroundStyle(Color(hex: 0x474638))
                    Text("28분 전 / regular-12")
                        .typography(.regular_12)
                        .foregroundStyle(Color(hex: 0x534C44, opacity: 0.5))
                    Text("이지혜 / semibold-28")
                        .typography(.semibold_28)
                        .foregroundStyle(DesignCore.black)
                    Text("1998년생 / medium-14")
                        .typography(.medium_14)
                        .foregroundStyle(DesignCore.grey200)
                    Text("직업 / medium-14")
                        .typography(.medium_14)
                        .foregroundStyle(DesignCore.darkGreen)
                    Text("초등학교 교사 / medium-16")
                        .typography(.medium_16)
                        .foregroundStyle(DesignCore.darkGreen)
                    Text("취미 / semibold-24")
                        .typography(.semibold_24)
                        .foregroundStyle(Color(hex: 0x15394B))
                    Text("연락한 지 2일차 / medium-18")
                        .typography(.medium_18)
                        .foregroundStyle(Color(hex: 0x534C44))
                    Text("3일차까지 10시간 24분 43초 남았어요 / regular-14")
                        .typography(.regular_14)
                        .foregroundStyle(Color(hex: 0x534C44))
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("three-days DesignSystem")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DesignPreviewView()
}
