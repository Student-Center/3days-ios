import SwiftUI
import DesignCore
import DesignPreview
import CommonKit
import Main

@main
struct ThreeDaysApp: App {
    @ObservedObject var coordinator = AppCoordinator.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottomLeading) {
                rootView
                #if STAGING || DEBUG
                debugMenuPicker
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
                #endif
            }
        }
    }
    
    @ViewBuilder
    var rootView: some View {
        NavigationStack(
            path: $coordinator.navigationStack
        ) {
            coordinator.rootView
                .navigationDestination(
                    for: PathType.self
                ) { feature in
                    feature.view
                }
        }
    }

    #if STAGING || DEBUG
    @ViewBuilder
    var debugMenuPicker: some View {
        Menu("🚀 개발모드") {
            ForEach(PathType.debugPreviewTypes, id: \.self) { feature in
                Button(feature.name) {
                    coordinator.changeRootView(feature)
                }
            }
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .typography(.semibold_14)
        .tint(DesignCore.Colors.grey300)
    }
    #endif
}
