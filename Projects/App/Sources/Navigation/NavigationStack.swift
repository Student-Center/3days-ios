//
//  NavigationStack.swift
//  three-days-dev
//
//  Created by 김지수 on 9/30/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import SignUp
import DesignPreview

extension PathType {
    @ViewBuilder
    var view: some View {
        switch self {
        case .designPreview:
            DesignPreviewView()
        case .main:
            SplashAnimatedView()
        case .signUp(let subView):
            switch subView {
            case .authPhoneInput:
                AuthPhoneInputView()
            case .authPhoneVerify:
                AuthPhoneVerifyView()
            case .authAgreement:
                AuthAgreementView()
                
            case .authGreeting:
                AuthGreetingView()
            case .authProfileGender:
                AuthProfileGenderInputView()
            case .authProfileAge:
                AuthProfileAgeInputView()
            }
        }
    }
}

extension AppCoordinator {
    @ViewBuilder
    var rootView: some View {
        navigationStack[0].view
    }
}
