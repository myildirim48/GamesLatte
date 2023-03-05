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
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 31),
            widthAnchor.constraint(equalToConstant: 35)
        ])
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton){
        
            UIView.transition(with: self, duration: 0.25,options: .transitionCrossDissolve) {
                self.isSelected = !self.isSelected
            }
        }
    
    
}
