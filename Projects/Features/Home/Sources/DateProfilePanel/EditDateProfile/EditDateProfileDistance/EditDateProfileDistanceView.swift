//
//  EditDateProfileDistanceView.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct EditDateProfileDistanceView: View {
    
    @StateObject var container: MVIContainer<EditDateProfileDistanceIntent.Intentable, EditDateProfileDistanceModel.Stateful>
     
    private var intent: EditDateProfileDistanceIntent.Intentable { container.intent }
    private var state: EditDateProfileDistanceModel.Stateful { container.model }
    
    public init() {
        let model = EditDateProfileDistanceModel()
        let intent = EditDateProfileDistanceIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as EditDateProfileDistanceIntent.Intentable,
            model: model as EditDateProfileDistanceModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            Text("Hello MVI")
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
        EditDateProfileDistanceView()
    }
}
