//
//  ScreenShotsCell.swift
//  LatteGames
//
//  Created by YILDIRIM on 6.03.2023.
//

import UIKit

class ScreenShotsCell: UICollectionViewCell {
    
    static let reuseId = "screenshots-cell-identifier"
    
    let imageView = LatteImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confgire()
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func confgire(){
        addSubviews(imageView)
        
        imageView.layer.cornerRadius = 15
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        

    }
}
