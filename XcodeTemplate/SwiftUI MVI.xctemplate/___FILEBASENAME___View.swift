//___FILEHEADER___

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct ___FILEBASENAMEASIDENTIFIER___: View {
    
    @StateObject var container: MVIContainer<___VARIABLE_productName___Intent.Intentable, ___VARIABLE_productName___Model.Stateful>
    
    private var intent: ___VARIABLE_productName___Intent.Intentable { container.intent }
    private var state: ___VARIABLE_productName___Model.Stateful { container.model }
    
    public init() {
        let model = ___VARIABLE_productName___Model()
        let intent = ___VARIABLE_productName___Intent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as ___VARIABLE_productName___Intent.Intentable,
            model: model as ___VARIABLE_productName___Model.Stateful,
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
        ___FILEBASENAMEASIDENTIFIER___()
    }
}
