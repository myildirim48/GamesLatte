//
//  RatingInfoView.swift
//  LatteGames
//
//  Created by YILDIRIM on 5.03.2023.
//

import UIKit


enum RatingInfoType:String{
    case expectional,recommended,meh,skip
}
class RatingInfoView: UIView {

     let imageLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
     let textLabel = LatteLabel(textAligment: .center, font: Theme.fonts.secondaryLabel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageEmoji: RatingInfoType, percent: String = " ") {
        textLabel.text = percent
        
        switch imageEmoji {
        case .expectional:
            imageLabel.text =  "🤩"
        case .recommended:
            imageLabel.text =  "👍🏼"
        case .meh:
            imageLabel.text =  "🤷🏻"
        case .skip:
            imageLabel.text =  "👎🏼"
        }
    }
    
    private func configure(){
        addSubviews(imageLabel,textLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerXAnchor.constraint(equalTo: imageLabel.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor,constant: 3),
            
            heightAnchor.constraint(equalToConstant: 45),
            widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
}
