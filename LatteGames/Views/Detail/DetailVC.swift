//
//  DetailVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit
class DetailVC: UIViewController {
    
    var selectedGame: GameDetail?
    
    private let environment: Environment!
    
    let gameImageView = UIImageView()
    let nameLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let genresLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    
    let ratingLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let ratingLabelImage = UIImageView(image: .init(systemName: "star.fill"))
    let releasedDateLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let releasedDateLabelImage = UIImageView(image: .init(systemName: "calendar.badge.plus"))

    let expectionalLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let expectionalLabelImage = UIImageView(image: .init(systemName: "hand.thumbsup.fill"))
    let recommendedLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let recommendedLabelImage = UIImageView(image: .init(systemName: "calendar.badge.plus"))
    let mehLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let mehLabelImage = UIImageView(image: .init(systemName: "calendar.badge.plus"))
    let skipLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let skipLabelImage = UIImageView(image: .init(systemName: "calendar.badge.plus"))
    
    required init(environemnt: Environment) {
        self.environment = environemnt
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure(){
        view.addSubviews(gameImageView,nameLabel,genresLabel,ratingLabel,ratingLabelImage,releasedDateLabel,releasedDateLabelImage,expectionalLabel,expectionalLabelImage,recommendedLabel,recommendedLabelImage,mehLabel,mehLabelImage,skipLabel,skipLabelImage)
        
        
    }
}
