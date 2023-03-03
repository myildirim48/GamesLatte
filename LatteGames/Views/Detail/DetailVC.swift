//
//  DetailVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit
class DetailVC: UIViewController {
    
    var selectedGame: GameDetail? {
        didSet {
            update()
        }
    }
    
    private let environment: Environment!
    
    let gameImageView = LatteImageView(frame: .zero)
    let nameLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let publishersLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let genresLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    
    
    let ratingLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let ratingLabelImage = LatteImageView(systemImageName: "star.fill")
    let releasedDateLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let releasedDateLabelImage = LatteImageView(systemImageName: "calendar.badge.plus")
    
    let expectionalLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let expectionalLabelImage = LatteImageView(systemImageName: "hand.thumbsup.fill")
    let recommendedLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let recommendedLabelImage = LatteImageView(systemImageName: "calendar.badge.plus")
    let mehLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let mehLabelImage = LatteImageView(systemImageName: "calendar.badge.plus")
    let skipLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let skipLabelImage = LatteImageView(systemImageName: "calendar.badge.plus")
    
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
    
    private func update(){
        guard let selectedGame = selectedGame else {
            return
        }
        
        Task { self.gameImageView.image = await ImageFetcher.shared.downloadImage(from: selectedGame.backgroundImage ?? "" )}
        
        nameLabel.text = selectedGame.name
        publishersLabel.text = selectedGame.publishers.map({ $0.name }).joined(separator: ", ")
        genresLabel.text = selectedGame.publishers.map({ $0.name }).joined(separator: ", ")
        
        releasedDateLabel.text = selectedGame.released.transformStringToDate().dateToString()
        ratingLabel.text = "\(selectedGame.rating ?? 0.0) / 5"
        
        selectedGame.ratings?.forEach({ item in
            switch item.title {
            case .exceptional:
                expectionalLabel.text = String(item.percent ?? 0.0)
            case .recommended:
                recommendedLabel.text = String(item.percent ?? 0.0)
            case .meh:
                mehLabel.text = String(item.percent ?? 0.0)
            case .skip:
                skipLabel.text = String(item.percent ?? 0.0)
            case .none:
                break
            }
            })
        
    }
                                      
    private func configure(){
        view.addSubviews(gameImageView,nameLabel,genresLabel,ratingLabel,ratingLabelImage,releasedDateLabel,releasedDateLabelImage,expectionalLabel,expectionalLabelImage,recommendedLabel,recommendedLabelImage,mehLabel,mehLabelImage,skipLabel,skipLabelImage,publishersLabel)
        
        let innerSpace:CGFloat = 10
        let outerSpace:CGFloat = 20
        
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: innerSpace),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: innerSpace),
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -outerSpace),
            
            publishersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpace),
            publishersLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace),
            
            genresLabel.topAnchor.constraint(equalTo: publishersLabel.bottomAnchor,constant: innerSpace),
            genresLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace),
            genresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -outerSpace),
            
            releasedDateLabelImage.topAnchor.constraint(equalTo: genresLabel.bottomAnchor,constant: outerSpace),
            releasedDateLabelImage.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace),
            
            releasedDateLabel.centerYAnchor.constraint(equalTo: releasedDateLabelImage.centerYAnchor),
            releasedDateLabel.leadingAnchor.constraint(equalTo: releasedDateLabelImage.trailingAnchor,constant: innerSpace),
            
            ratingLabelImage.topAnchor.constraint(equalTo: releasedDateLabel.bottomAnchor,constant: innerSpace),
            ratingLabelImage.leadingAnchor.constraint(equalTo: releasedDateLabel.trailingAnchor,constant: innerSpace),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingLabelImage.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingLabelImage.trailingAnchor,constant: innerSpace),
            
            expectionalLabelImage.topAnchor.constraint(equalTo: gameImageView.bottomAnchor,constant: outerSpace),
            expectionalLabelImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: innerSpace),
            
            expectionalLabel.centerXAnchor.constraint(equalTo: expectionalLabelImage.centerXAnchor),
            
            recommendedLabelImage.centerYAnchor.constraint(equalTo: expectionalLabelImage.centerYAnchor),
            recommendedLabelImage.leadingAnchor.constraint(equalTo: expectionalLabelImage.trailingAnchor,constant: outerSpace),
            
            recommendedLabel.centerXAnchor.constraint(equalTo: recommendedLabelImage.centerXAnchor),
            
            mehLabelImage.centerYAnchor.constraint(equalTo: expectionalLabelImage.centerYAnchor),
            mehLabelImage.leadingAnchor.constraint(equalTo: recommendedLabelImage.trailingAnchor,constant: outerSpace),
            
            mehLabel.centerXAnchor.constraint(equalTo: mehLabelImage.centerXAnchor),
            
            skipLabelImage.centerYAnchor.constraint(equalTo: expectionalLabelImage.centerYAnchor),
            skipLabelImage.leadingAnchor.constraint(equalTo: mehLabelImage.trailingAnchor,constant: outerSpace),
            
            skipLabel.centerXAnchor.constraint(equalTo: skipLabelImage.centerXAnchor)
            
        ])
    }
}
