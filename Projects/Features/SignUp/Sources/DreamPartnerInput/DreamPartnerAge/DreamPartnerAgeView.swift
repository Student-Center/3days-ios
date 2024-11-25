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
import Model

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
    
    public init(_ input: SignUpFormDomain) {
        let model = DreamPartnerAgeModel()
        let intent = DreamPartnerAgeIntent(
            model: model,
            input: .init(input: input)
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
                        AgeUpDownView(
                            type: .up,
                            upperValue: upperValue,
                            lowerValue: lowerValue,
                            showPicker: showUpperPicker
                        )
                        .onTapGesture {
                            showUpperPicker = true
                            showLowerPicker = false
                        }
                        AgeUpDownView(
                            type: .down,
                            upperValue: upperValue,
                            lowerValue: lowerValue,
                            showPicker: showLowerPicker
                        )
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
                    AgePickerView(
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
                    intent.onTapNextButton(state: state)
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
        .setNavigation(showLeftBackButton: false) {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        DreamPartnerAgeView(.mock)
    }
}
