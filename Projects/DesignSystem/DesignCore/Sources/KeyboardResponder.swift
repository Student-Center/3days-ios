//
//  KeyboardResponder.swift
//  DesignCore
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import Combine

public class KeyboardResponder: ObservableObject {
    @Published public var keyboardHeight: CGFloat = 0
    @Published public var isKeyboardShown: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willShow
            .merge(with: willHide)
            .sink { [weak self] notification in
                guard let self = self else { return }
                if notification.name == UIResponder.keyboardWillShowNotification {
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height
                        self.isKeyboardShown = true  // 키보드가 올라온 상태
                    }
                } else {
                    self.keyboardHeight = 0
                    self.isKeyboardShown = false  // 키보드가 내려간 상태
                }
            }
            .store(in: &cancellables)
    }
}
