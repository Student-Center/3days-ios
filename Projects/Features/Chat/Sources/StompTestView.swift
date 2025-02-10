//
//  StompTestView.swift
//  Chat
//
//  Created by 김지수 on 1/28/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct StompTestView: View {
    
    @StateObject var container: MVIContainer<StompTestIntent.Intentable, StompTestModel.Stateful>
    
    private var intent: StompTestIntent.Intentable { container.intent }
    private var state: StompTestModel.Stateful { container.model }
    
    public init() {
        let model = StompTestModel()
        let intent = StompTestIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as StompTestIntent.Intentable,
            model: model as StompTestModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            Text("Welcome to STOMP TestBed")
            
            Button("Connect") {
                intent.requestConnect()
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        StompTestView()
    }
}
