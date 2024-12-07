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
    @State var isLoading: Bool = false
    
    let showButton: Bool
    let navigationTitle: String?
    let buttonTitle: String
    var backHandler: (() -> Void)?
    var buttonHandler: ((Data?) async -> Void)?
    
    public init(
        image: UIImage?,
        isPresented: Binding<Bool>,
        showButton: Bool,
        navigationTitle: String?,
        buttonTitle: String,
        backHandler: (() -> Void)? = nil,
        buttonHandler: ((Data?) async -> Void)? = nil  // 클로저 타입 변경
    ) {
        self.image = image
        self._isPresented = isPresented
        self.showButton = showButton
        self.navigationTitle = navigationTitle
        self.buttonTitle = buttonTitle
        self.backHandler = backHandler
        self.buttonHandler = buttonHandler
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        guard let originalData = image.pngData() else { return nil }
        if originalData.count <= 5 * 1024 * 1024 { return originalData }
        
        // PNG 이미지 크기 조절
        let scale = CGFloat(0.7)  // 10% 씩 크기 감소
        var newSize = image.size
        var whileCount = 0
        while true {
            print(whileCount)
            whileCount += 1
            newSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let resizedImage = renderer.image { context in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
            
            if let data = resizedImage.pngData(),
               data.count <= 4 * 1024 * 1024 {
                return data
            }
            
            if newSize.width < 200 || newSize.height < 200 {
                break
            }
        }
        return nil
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
                    Task {
                        if let image = image,
                           let compressedImage = compressImage(image) {
                            await buttonHandler?(compressedImage)
                        }
                    }
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
        .setLoading(isLoading)
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
