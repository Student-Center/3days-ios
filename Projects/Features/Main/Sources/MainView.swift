//
//  MainView.swift
//  Main
//
//  Created by 김지수 on 8/17/24.
//

import SwiftUI
import DesignCore

public struct MainView: View {
    
    public init() {}
    
    public var body: some View {
        Text("This is Main View in Main Feature!")
            .foregroundStyle(Color.red)
            .background(LinearGradient.gradientA)
            .font(.bold.displayLg)
    }
}

#Preview {
    MainView()
}
