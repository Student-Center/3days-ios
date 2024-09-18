import SwiftUI
import DesignCore
import DesignPreview
import CoreKit
import Main

@main
struct ThreeDaysApp: App {
    let coordinator = AppCoordinator.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottomLeading) {
                rootView
                #if DEBUG
                debugMenuPicker
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
                #endif
            }
        }
    }
    
    @ViewBuilder
    var rootView: some View {
        switch coordinator.rootView {
        case .designPreview:
            DesignPreviewView()
        case .main:
            MainView()
        }
    }

    #if DEBUG
    @ViewBuilder
    var debugMenuPicker: some View {
        Menu("🚀 개발모드") {
            ForEach(FeatureType.allCases, id: \.self) { feature in
                Button(feature.name) {
                    coordinator.changeRootView(feature)
                }
            }
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .typography(.semibold_14)
        .tint(DesignCore.grey300)
    }
    #endif
}
