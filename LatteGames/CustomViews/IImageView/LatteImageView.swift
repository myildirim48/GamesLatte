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
        configure(imageName: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(systemImageName:String) {
        self.init(frame: .zero)
        self.configure(imageName: systemImageName)
    }
    
    private func configure(imageName:String) {
        clipsToBounds = true
        contentMode = .scaleToFill
        image = .init(systemName: imageName)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
