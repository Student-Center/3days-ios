//
//  SplashAnimatedView.swift
//  three-days-dev
//
//  Created by 김지수 on 9/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import CoreKit
import CommonKit

enum SplashAnimationStep: CaseIterable {
    case first, second, third, fourth, fifth, sixth
    
    var color: Color {
        switch self {
        case .first: Color(hex: 0xE4DED7)
        case .second: Color(hex: 0xDFE7D1)
        case .third: Color(hex: 0xD7D7EA)
        case .fourth: Color(hex: 0xECDAE3)
        default: Color(hex: 0xF5F1EE)
        }
    }
    
    var interval: Double {
        switch self {
        case .first: 1.0
        default: 0.5
        }
    }
}

struct IconState: Identifiable {
    let id: Int
    var offset: CGSize
    var rotation: Angle
    var opacity: Double
}

struct SplashAnimatedView: View {
    @State private var animationStep: SplashAnimationStep = .first
    @State private var cycleCompleted = false
    @State private var otherViewOpacity: CGFloat = 0.0
    @State private var showLetterAnimation = false
    @State private var iconStates: [IconState] = [
        IconState(
            id: 0,
            offset: .zero,
            rotation: .degrees(
                0
            ),
            opacity: 1
        ),
        IconState(
            id: 1,
            offset: .zero,
            rotation: .degrees(
                -5.47
            ),
            opacity: 0
        ),
        IconState(
            id: 2,
            offset: .zero,
            rotation: .degrees(
                4.98
            ),
            opacity: 0
        ),
        IconState(
            id: 3,
            offset: .zero,
            rotation: .degrees(15.52),
            opacity: 0
        )
    ]
    
    var body: some View {
        VStack(spacing: 84) {
            Spacer()
            
            Text("3일동안 딱 한 사람만 알아가는\n새로운 설렘의 시작")
                .typography(.semibold_24)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignCore.Colors.grey500)
                .opacity(otherViewOpacity)
            
            ZStack {
                DesignCore.Images.logoSmall.image
                    .offset(iconStates[0].offset)
                    .rotationEffect(iconStates[0].rotation)
                    .opacity(iconStates[0].opacity)
                
                DesignCore.Images.day1.image
                    .offset(iconStates[1].offset)
                    .rotationEffect(iconStates[1].rotation)
                    .opacity(iconStates[1].opacity)
                
                DesignCore.Images.day2.image
                    .offset(iconStates[2].offset)
                    .rotationEffect(iconStates[2].rotation)
                    .opacity(iconStates[2].opacity)
                
                DesignCore.Images.day3.image
                    .offset(iconStates[3].offset)
                    .rotationEffect(iconStates[3].rotation)
                    .opacity(iconStates[3].opacity)
            }
            
            CTABorderButton(
                title: "휴대폰 번호로 시작하기",
                backgroundStyle: LinearGradient.gradientA,
                isActive: true,
                isShowLetter: $showLetterAnimation
            ) {
                AppCoordinator.shared.navigationStack.append(
                    .signUp(.authPhoneInput)
                )
            }
            .frame(height: 70)
            .padding(.horizontal, 50)
            .opacity(otherViewOpacity)
            
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .textureBackground(animationStep.color)
        .task {
            await runSingleCycle()
        }
    }
    
    private func runSingleCycle() async {
        for step in SplashAnimationStep.allCases.dropFirst() {
            guard !cycleCompleted else { break }
            try? await Task.sleep(for: .seconds(step.interval))
            withAnimation(.interactiveSpring(duration: 0.75)) {
                updateIconStates(for: step)
                animationStep = step
            }
        }
        cycleCompleted = true
        withAnimation {
            showLetterAnimation = true
        }
    }
    
    private func updateIconStates(for step: SplashAnimationStep) {
        switch step {
        case .second:
            iconStates[0].opacity = 0
            iconStates[1].opacity = 1
        case .third:
            iconStates[2].opacity = 1
        case .fourth:
            iconStates[3].opacity = 1
        case .fifth:
            iconStates[1].offset = CGSize(width: -28, height: -8)
            iconStates[2].offset = .zero
            iconStates[3].offset = CGSize(width: 28, height: 8)
            iconStates[1].rotation = .zero
            iconStates[2].rotation = .zero
            iconStates[3].rotation = .zero
            otherViewOpacity = 0.3
        case .sixth:
            iconStates[1].offset = CGSize(width: -64, height: -24)
            iconStates[2].offset = .zero
            iconStates[3].offset = CGSize(width: 64, height: 24)
            otherViewOpacity = 1.0
        default:
            break
        }
    }
}

#Preview {
    SplashAnimatedView()
}
