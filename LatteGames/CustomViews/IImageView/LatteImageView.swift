//
//  LatteImageView.swift
//  LatteGames
//
//  Created by YILDIRIM on 2.03.2023.
//

import UIKit
class LatteImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(systemImageName:String, tintColor: UIColor? = nil) {
        self.init(frame: .zero)
        configure()
        setImage(imageName: systemImageName)
        self.tintColor = tintColor
    }
    
    private func configure() {
        clipsToBounds = true
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setImage(imageName:String){
        image = .init(systemName: imageName)
    }
}
