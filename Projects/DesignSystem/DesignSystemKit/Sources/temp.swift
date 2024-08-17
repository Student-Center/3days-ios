import SwiftUI

public extension Color {
    static var tempColor: Color {
        return Color(
            uiColor: .init(
                red: 0.5,
                green: 0.5,
                blue: 0.5,
                alpha: 1
            )
        )
    }
}
