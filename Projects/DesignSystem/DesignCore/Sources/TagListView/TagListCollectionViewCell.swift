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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    private func setupUI() {
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
                contentView.backgroundColor = UIColor(hex: 0x93CAF8)
                contentView.layer.borderColor = UIColor.white.cgColor
                contentView.layer.borderWidth = 3
            } else {
                label.textColor = UIColor(resource: .blue500)
                contentView.backgroundColor = .white
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
