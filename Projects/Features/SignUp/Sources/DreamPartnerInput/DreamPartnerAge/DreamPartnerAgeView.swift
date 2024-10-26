//
//  DreamPartnerAgeView.swift
//  SignUp
//
//  Created by 김지수 on 10/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

enum AgeUpDownType {
    case up
    case down
    
    var imoji: String {
        switch self {
        case .up: "👆"
        case .down: "👇"
        }
    }
    
    var text: String {
        switch self {
        case .up: "위"
        case .down: "아래"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .up: DesignCore.Colors.green50
        case .down: DesignCore.Colors.pink50
        }
    }
    
    var borderColor: Color {
        switch self {
        case .up: .init(hex: 0xA1BA91)
        case .down: .init(hex: 0xE6B1C4)
        }
    }
    
    var textColor: Color {
        switch self {
        case .up: DesignCore.Colors.green500
        case .down: DesignCore.Colors.pink500
        }
    }
}

public struct DreamPartnerAgeView: View {
    
    @StateObject var container: MVIContainer<DreamPartnerAgeIntent.Intentable, DreamPartnerAgeModel.Stateful>
    
    private var intent: DreamPartnerAgeIntent.Intentable { container.intent }
    private var state: DreamPartnerAgeModel.Stateful { container.model }
    
    public init() {
        let model = DreamPartnerAgeModel()
        let intent = DreamPartnerAgeIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as DreamPartnerAgeIntent.Intentable,
            model: model as DreamPartnerAgeModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    @State private var upperValue: String?
    @State private var lowerValue: String?
    @State private var showUpperPicker = true
    @State private var showLowerPicker = false
    
    public var body: some View {
        ZStack {
            VStack {
                ProfileInputTemplatedView(
                    currentPage: 1,
                    maxPage: 3,
                    subMessage: "연상, 동갑, 연하... 최대한 맞춰줄께요!",
                    mainMessage: "상대의 나이대는\n어느 정도가 좋을까요?"
                ) {
                    VStack {
                        ageUpDownView(type: .up)
                            .onTapGesture {
                                showUpperPicker = true
                                showLowerPicker = false
                            }
                        ageUpDownView(type: .down)
                            .onTapGesture {
                                showUpperPicker = false
                                showLowerPicker = true
                            }
                    }
                }
                
                Spacer()
            }
            if showUpperPicker || showLowerPicker {
                VStack {
                    Spacer()
                    BottomSheetPickerView(
                        selectedValue: showUpperPicker ? $upperValue : $lowerValue
                    )
                    .padding(.bottom, 90)
                    .frame(height: 300)
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                CTABottomButton(title: "다음") {
                        
                }
            }
        }
        .onChange(of: upperValue) {
            intent.onChangeUpperValue(value: upperValue)
        }
        .onChange(of: lowerValue) {
            intent.onChangeLowerValue(value: lowerValue)
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
    
    @ViewBuilder
    func ageUpDownView(type: AgeUpDownType) -> some View {
        HStack(spacing: 8) {
            HStack {
                Text(type.imoji)
                Text("내 나이보다")
                Text(type.text)
                Text("로")
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 4)
                    .stroke(
                        borderColor(type: type),
                        lineWidth: 10
                    )
                    .fill(type.backgroundColor)
                    .shadow(.default)
                switch type {
                case .up:
                    Text(upperValue ?? "-")
                        .pretendard(weight: ._600, size: 36)
                        .foregroundStyle(type.textColor)
                case .down:
                    Text(lowerValue ?? "-")
                        .pretendard(weight: ._600, size: 36)
                        .foregroundStyle(type.textColor)
                }
            }
            .frame(width: 92, height: 62)
            .padding(.horizontal, 2)
            
            Text("살")
        }
        .padding(.horizontal, 8)
        .foregroundStyle(DesignCore.Colors.grey300)
        .typography(.semibold_18)
    }
    
    func borderColor(type: AgeUpDownType) -> Color {
        switch type {
        case .up: showUpperPicker ? type.borderColor : .white
        case .down: showLowerPicker ? type.borderColor : .white
        }
    }
}

struct BottomSheetPickerView: View {
    @Binding var selectedValue: String?
    
    var body: some View {
        Picker("숫자 선택", selection: $selectedValue) {
            Text("상관없어요")
                .tag(String?.none)
            ForEach(0...15, id: \.self) { number in
                Text("\(number)")
                    .tag(String?(String(number)))
            }
        }
        .pickerStyle(.wheel)
        .padding(.bottom)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        DreamPartnerAgeView()
    }
}
