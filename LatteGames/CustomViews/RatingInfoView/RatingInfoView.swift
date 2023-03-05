//
//  RatingInfoView.swift
//  LatteGames
//
//  Created by YILDIRIM on 5.03.2023.
//

import UIKit
class RatingInfoView: UIView {
    
    private let imageLabel = LatteLabel(textAligment: .left, font: Theme.fonts.secondaryLabel)
    private let textLabel = LatteLabel(textAligment: .center, font: Theme.fonts.secondaryLabel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(imageEmoji: String, percent:String) {
        self.init(frame: .zero)
        self.imageLabel.text = imageEmoji
        self.textLabel.text = percent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        addSubviews(imageLabel,textLabel)
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: imageLabel.centerYAnchor),
            textLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor,constant: 10)
        ])
    }
    
}
