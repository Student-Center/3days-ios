//
//  Toast.swift
//  DesignCore
//
//  Created by 김지수 on 11/17/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import UIKit
import Toast

public class ToastHelper {
    public enum ToastStyle {
        case normal
        case error
        
        var icon: UIImage? {
            switch self {
            case .normal: return nil
            case .error: return DesignCore.Images.alert.uiImage
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .normal: .white
            case .error: .init(hex: 0xFFF5F8)
            }
        }
    }
    
    private static let manager = ToastManager.shared
    public static func show(
        message: String,
        style: ToastStyle = .normal
    ) {
        manager.showToast(message: message, style: style)
    }
}

final class ToastManager {
    static let shared = ToastManager()
    private var toastWindow: UIWindow?
    
    private init() {}
    
    func showToast(
        message: String,
        style: ToastHelper.ToastStyle = .normal,
        duration: TimeInterval = 3.0
    ) {
        DispatchQueue.main.async {
            self.createToastWindow(
                with: message,
                style: style
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
                self.clearToast()
            }
        }
    }
    
    private func createToastWindow(
        with message: String,
        style: ToastHelper.ToastStyle
    ) {
        guard toastWindow == nil else { return }
        
        let toastWindow = UIWindow(frame: UIScreen.main.bounds)
        toastWindow.windowLevel = .statusBar + 1
        toastWindow.backgroundColor = .clear
        
        let containerVC = UIViewController()
        containerVC.view.backgroundColor = .clear
        
        let viewConfig: ToastViewConfiguration = .init(
            minHeight: 52,
            minWidth: Device.width - 56,
            darkBackgroundColor: style.backgroundColor,
            lightBackgroundColor: style.backgroundColor,
            titleNumberOfLines: 0,
            subtitleNumberOfLines: 0,
            cornerRadius: 14
        )
        let toastConfig: ToastConfiguration = .init(
            direction: .bottom,
            dismissBy: [
                .tap,
                .swipe(direction: .natural),
                .time(time: 3)
            ],
            enteringAnimation: .default,
            exitingAnimation: .default,
            allowToastOverlap: false
        )
        
        let toast: Toast
        if let icon = style.icon {
            toast = Toast.default(
                image: icon,
                title: createAttributedTitle(with: message),
                viewConfig: viewConfig,
                config: toastConfig
            )
        } else {
            toast = Toast.text(
                createAttributedTitle(with: message),
                subtitle: nil,
                viewConfig: viewConfig,
                config: toastConfig
            )
        }
        
        if style == .error {
            toast.view.layer.borderWidth = 1
            toast.view.layer.borderColor = UIColor(hex: 0xF2597F)
                .withAlphaComponent(0.5)
                .cgColor
        }
        toast.show(haptic: .success)
    }
    
    private func createAttributedTitle(with message: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(._500, size: 16),
            .foregroundColor: UIColor(DesignCore.Colors.grey400),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]
        
        return NSAttributedString(string: message, attributes: attributes)
    }
    
    private func clearToast() {
        self.toastWindow = nil
    }
}
