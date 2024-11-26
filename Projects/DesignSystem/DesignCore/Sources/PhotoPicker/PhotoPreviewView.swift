//
//  PhotoPreviewView.swift
//  DesignCore
//
//  Created by 김지수 on 11/27/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit

public struct PhotoPreviewView: View {
    
    let image: UIImage?
    @Binding var isPresented: Bool
    
    let showButton: Bool
    let navigationTitle: String?
    let buttonTitle: String
    var backHandler: (() -> Void)?
    var buttonHandler: (() -> Void)?
    
    public init(
        image: UIImage?,
        isPresented: Binding<Bool>,
        showButton: Bool,
        navigationTitle: String?,
        buttonTitle: String,
        backHandler: (() -> Void)? = nil,
        buttonHandler: (() -> Void)? = nil
    ) {
        self.image = image
        self._isPresented = isPresented
        self.showButton = showButton
        self.navigationTitle = navigationTitle
        self.buttonTitle = buttonTitle
        self.backHandler = backHandler
        self.buttonHandler = buttonHandler
    }
    
    public var body: some View {
        ZStack {
            Color.black
            if let image {
                VStack {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width)
                    Spacer()
                }
            }
            if showButton {
                CTABottomButton(
                    title: buttonTitle,
                    backgroundStyle: LinearGradient.gradientA
                ) {
                    buttonHandler?()
                }
            }
        }
        .ignoresSafeArea()
        .navigationTitle(navigationTitle == nil ? "" : navigationTitle!)
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    backHandler?()
                } label: {
                    Image(systemName: "arrow.left")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                
            }
        }
    }
}
