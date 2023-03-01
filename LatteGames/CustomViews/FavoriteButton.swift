//
//  FavoriteButton.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
class FavoriteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        setImage(UIImage(systemName: "heart"), for: .normal)
        setImage(UIImage(systemName: "heart.fill"), for: .selected)
        tintColor = .systemRed
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
    }
    
}
