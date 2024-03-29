//
//  GameCell.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit

protocol GameCellDelegate: NSObject {
    func gameCellFavoriteButtonTapped(cell:GameCell)
}

class GameCell: UICollectionViewCell {
    static let reuseId = "game-cell-identifier"
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let imageView = LatteImageView(frame: .zero)
    let nameLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let favoritesButton = FavoriteButton(frame: .zero)
    let genresLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    
    let ratingLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let ratingLabelImage = UIImageView()
    let releasedLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let releasedImage = UIImageView()
    let suggestionLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let suggestionImage = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: GameCellDelegate?
    
    @objc func favoritesButtonTapped(_ sender: UIButton){
        guard let delegate = delegate else { return }
                delegate.gameCellFavoriteButtonTapped(cell: self)
    }
    
    var gameData : DisplayableResource? {
        didSet {
            update()
        }
    }
    
    //MARK: - Private Funcs
    
    private func update() {
        guard let gameData = gameData else {
            return
        }
        
        nameLabel.text = gameData.name
        genresLabel.text = gameData.genres?.map{$0.name ?? ""}.joined(separator: ", ")
        ratingLabel.text = "\(gameData.rating ?? 0.0)/5"
        releasedLabel.text = gameData.released?.transformStringToDate().dateToString()
        suggestionLabel.text = String(gameData.suggestionsCount ?? 0)
        
        activityIndicator.startAnimating()
        
        if let imgData = gameData.imageData {
            imageView.image = UIImage(data: imgData)
            self.activityIndicator.stopAnimating()
        }else {
            DispatchQueue.main.async {
                Task {
                    self.imageView.image = await ImageFetcher.shared.downloadImage(from: gameData.backgroundImage ?? "")
            self.activityIndicator.stopAnimating()
                }
                
            }
        }

    }
    
    private func configure() {
        addSubviews(imageView,nameLabel,ratingLabel,ratingLabelImage,genresLabel,favoritesButton,releasedImage,releasedLabel,suggestionImage,suggestionLabel,activityIndicator)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        activityIndicator.hidesWhenStopped = true
        
        ratingLabelImage.image = UIImage(systemName: "star.fill")
        ratingLabelImage.tintColor = .systemYellow
        
        releasedImage.image = UIImage(systemName: "calendar.badge.plus")
        releasedImage.tintColor = .systemGreen
        
        suggestionImage.image = UIImage(systemName: "hand.thumbsup.fill")
        suggestionImage.tintColor = .systemBlue
        
        ratingLabel.textColor = .secondaryLabel
        releasedLabel.textColor = .secondaryLabel
        suggestionLabel.textColor = .secondaryLabel

        ratingLabelImage.translatesAutoresizingMaskIntoConstraints = false
        releasedImage.translatesAutoresizingMaskIntoConstraints = false
        suggestionImage.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        favoritesButton.addTarget(self, action: #selector(self.favoritesButtonTapped(_:)), for: .touchUpInside)

        let innerSpace = CGFloat(8)
        let outerSpace = CGFloat(20)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: outerSpace*8),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor,constant: innerSpace/2),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: innerSpace),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -outerSpace),
            
            genresLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpace/2),
            genresLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: innerSpace),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingLabelImage.trailingAnchor,constant: innerSpace/2),
            ratingLabel.widthAnchor.constraint(equalToConstant: 50),

            ratingLabelImage.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingLabelImage.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
            favoritesButton.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            favoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -outerSpace),

            releasedImage.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor,constant: innerSpace),
            releasedImage.leadingAnchor.constraint(equalTo: ratingLabelImage.leadingAnchor),
            
            releasedLabel.centerYAnchor.constraint(equalTo: releasedImage.centerYAnchor),
            releasedLabel.leadingAnchor.constraint(equalTo: releasedImage.trailingAnchor,constant: innerSpace/2),
            
            suggestionImage.topAnchor.constraint(equalTo: releasedImage.bottomAnchor,constant: innerSpace/2),
            suggestionImage.leadingAnchor.constraint(equalTo: releasedImage.leadingAnchor),
            suggestionImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -innerSpace),
            
            suggestionLabel.centerYAnchor.constraint(equalTo: suggestionImage.centerYAnchor),
            suggestionLabel.leadingAnchor.constraint(equalTo: suggestionImage.trailingAnchor,constant: innerSpace/2),
            
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            
        ])
        
    }
    
}
