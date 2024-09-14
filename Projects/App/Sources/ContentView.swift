import SwiftUI
import CoreKit
import NetworkKit
import ComponentsKit
import DesignCore
import Main

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .font(.pretendard(._300, size: 24))
                .pretendard(weight: ._300, size: 20)
                .robotoSlab(size: 12)
            
            MainView()
            
            SampleComponent()
                .foregroundStyle(Color.red)
        }
        .onAppear {
            Task {
                do {
                    try await AuthEndpoint.requestSMSVerification(phone: "010-4602-2274")
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
