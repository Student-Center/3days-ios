//
//  MVIContainer.swift
//  CoreKit
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import Combine

final public class MVIContainer<Intent, Model>: ObservableObject {
    // MARK: Public
    public let intent: Intent
    public var model: Model

    // MARK: private
    private var cancellable: Set<AnyCancellable> = []

    // MARK: Life cycle
    public init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}
