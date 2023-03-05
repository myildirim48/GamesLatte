//
//  LatteLabel.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
class LatteLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAligment: NSTextAlignment, font: UIFont,text: String = "",textColor: UIColor = .label) {
        self.init(frame: .zero)
        self.textAlignment = textAligment
        self.font = font
        self.text = text
        self.textColor = textColor
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
}
