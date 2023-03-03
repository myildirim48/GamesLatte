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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(systemImageName:String) {
        self.init(frame: .zero)
        setImage(imageName: systemImageName)
    }
    
    private func configure() {
        clipsToBounds = true
        contentMode = .scaleToFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setImage(imageName:String){
        image = .init(systemName: imageName)
    }
}
