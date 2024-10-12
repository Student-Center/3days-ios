//
//  TagListCollectionViewCell.swift
//  DesignCore
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import UIKit

class TagListCollectionViewCell: UICollectionViewCell {
    static let identifier = "TagListCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(._500, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradientLayer.frame = contentView.bounds
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    private func setupUI() {
        contentView.layer.addSublayer(backgroundGradientLayer)
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        updateAppearance(isTagSelected: false)
    }
    
    func configure(
        with subRegion: String,
        isSelected: Bool
    ) {
        label.text = subRegion
        self.updateAppearance(isTagSelected: isSelected)
    }
    
    private func updateAppearance(isTagSelected: Bool) {
        UIView.performWithoutAnimation {
            if isTagSelected {
                label.textColor = .white
                backgroundGradientLayer.colors = [
                    UIColor(hex: 0x93CAF8).cgColor,
                    UIColor(hex: 0x76B6EB).cgColor
                ]
                backgroundGradientLayer.backgroundColor = UIColor.clear.cgColor
                contentView.layer.borderColor = UIColor.white.cgColor
                contentView.layer.borderWidth = 3
            } else {
                label.textColor = UIColor(resource: .blue500)
                backgroundGradientLayer.colors = []
                backgroundGradientLayer.backgroundColor = UIColor.white.cgColor
                contentView.layer.borderColor = UIColor(hex: 0xDFE8EF).cgColor
                contentView.layer.borderWidth = 1
            }
        }
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
