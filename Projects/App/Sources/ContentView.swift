import SwiftUI
import CoreKit
import NetworkKit
import ComponentsKit
import DesignSystemKit
import Main

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
            
            MainView()
            
            SampleComponent()
                .foregroundStyle(Color.tempColor)
        }
        .onAppear {
            Task {
                do {
                    try await ExampleEndpoint.example.request()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
