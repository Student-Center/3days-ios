import SwiftUI
import CoreKit
import NetworkKit
import ComponentsKit
import DesignSystemKit
import Main

public struct ContentView: View {
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
            .onAppear {
                ThisIsCoreKit.something()
                ThisIsNetworkKit.something()
                print(ThisIsNetworkKit.thisServer)
            }
        
        MainView()
        
        SampleComponent()
            .foregroundStyle(Color.tempColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
