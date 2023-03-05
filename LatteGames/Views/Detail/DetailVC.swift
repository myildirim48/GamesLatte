//
//  DetailVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit
class DetailVC: UIViewController {
    
    var selectedGameID: Int?
    
    var selectedGame: GameDetail?
    
    
    private let environment: Environment!
    private var detailVM: DetailVM!
    
    let gameImageView = LatteImageView(frame: .zero)
    let nameLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let publishersLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel)
    let genresLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    
    let favoriteButton = FavoriteButton(frame: .zero)
    
    let ratingLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(75))
    let ratingLabelImage = LatteImageView(systemImageName: "star.fill",tintColor: .systemYellow)
    let releasedDateLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(75))
    let releasedDateLabelImage = LatteImageView(systemImageName: "calendar.badge.plus",tintColor: .systemGreen)
    let playtimeLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(75))
    let playtimeImage = LatteImageView(systemImageName: "clock.badge.checkmark",tintColor: .systemBlue)
    
    
    let recommendationView = UIView()
    let expectionalLabel = RatingInfoView()
    let stackView = UIStackView()
    let recommendedLabel = RatingInfoView()
    let mehLabel = RatingInfoView()
    let skipLabel = RatingInfoView()
    
    required init(environemnt: Environment) {
        self.environment = environemnt
        self.detailVM = DetailVM(environment: environment)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        self.detailVM = DetailVM(environment: environment)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        guard let gameID = selectedGameID else { return }
        detailVM.delegate = self
        detailVM.configure(gameID: gameID)
        detailVM.gameDetailsVoid = { data in
            self.update(with: data)
        }
    }
    
    private func update(with selectedGame: GameDetail?){
        guard let selectedGame = selectedGame else {
            return
        }
        
        Task { self.gameImageView.image = await ImageFetcher.shared.downloadImage(from: selectedGame.backgroundImage ?? "" )}
        
        nameLabel.text = selectedGame.name
        publishersLabel.text = selectedGame.publishers.map({ $0.name }).joined(separator: ", ")
        genresLabel.text = selectedGame.genres.map({ $0.name ?? " " }).joined(separator: ", ")
        
        releasedDateLabel.text = selectedGame.released.transformStringToDate().dateToString()
        ratingLabel.text = "\(selectedGame.rating ?? 0.0) / 5"
        playtimeLabel.text = "\(selectedGame.playtime) Hours Played."
        
        selectedGame.ratings?.forEach({ item in
            switch item.title {
            case .exceptional:
                expectionalLabel.set(imageEmoji: .expectional,percent:  String(item.percent ?? 0.0).appending("%"))
            case .recommended:
                recommendedLabel.set(imageEmoji: .recommended,percent: String(item.percent ?? 0.0).appending("%"))
            case .meh:
                mehLabel.set(imageEmoji: .meh,percent: String(item.percent ?? 0.0).appending("%"))
            case .skip:
                skipLabel.set(imageEmoji: .skip,percent: String(item.percent ?? 0.0).appending("%"))
            case .none:
                break
            }
        })
        
    }
    
    private func configure(){
        
        view.addSubviews(gameImageView,nameLabel,genresLabel,ratingLabel,ratingLabelImage,releasedDateLabel,releasedDateLabelImage,publishersLabel,playtimeImage,playtimeLabel,favoriteButton,recommendationView)
        
        recommendationView.addSubviews(expectionalLabel,recommendedLabel,mehLabel,skipLabel)
        
        let innerSpace:CGFloat = 5
        let outerSpace:CGFloat = 20
        
        view.backgroundColor = .systemBackground
        gameImageView.layer.cornerRadius = 10
        
        recommendationView.translatesAutoresizingMaskIntoConstraints = false
        recommendationView.layer.borderWidth = 1
        recommendationView.layer.borderColor = UIColor.systemGray6.cgColor
    
        
        NSLayoutConstraint.activate([
            
            gameImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: outerSpace*3),
            gameImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: outerSpace),
            gameImageView.heightAnchor.constraint(equalToConstant: 200),
            gameImageView.widthAnchor.constraint(equalToConstant: 130),
            
            nameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor,constant: innerSpace),
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace*2),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -outerSpace),
            
            publishersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpace),
            publishersLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            publishersLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            genresLabel.topAnchor.constraint(equalTo: publishersLabel.bottomAnchor,constant: innerSpace),
            genresLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            releasedDateLabelImage.topAnchor.constraint(equalTo: genresLabel.bottomAnchor,constant: outerSpace),
            releasedDateLabelImage.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace),
            
            releasedDateLabel.centerYAnchor.constraint(equalTo: releasedDateLabelImage.centerYAnchor),
            releasedDateLabel.leadingAnchor.constraint(equalTo: releasedDateLabelImage.trailingAnchor,constant: innerSpace),
            
            ratingLabelImage.topAnchor.constraint(equalTo: releasedDateLabel.bottomAnchor,constant: innerSpace),
            ratingLabelImage.leadingAnchor.constraint(equalTo: releasedDateLabelImage.leadingAnchor),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingLabelImage.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingLabelImage.trailingAnchor,constant: innerSpace),
            
            favoriteButton.centerYAnchor.constraint(equalTo: ratingLabelImage.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -outerSpace*2),
            
            
            playtimeImage.topAnchor.constraint(equalTo: ratingLabelImage.bottomAnchor,constant: innerSpace),
            playtimeImage.leadingAnchor.constraint(equalTo: ratingLabelImage.leadingAnchor),
            
            playtimeLabel.centerYAnchor.constraint(equalTo: playtimeImage.centerYAnchor),
            playtimeLabel.leadingAnchor.constraint(equalTo: playtimeImage.trailingAnchor,constant: innerSpace),
            
            recommendationView.topAnchor.constraint(equalTo: gameImageView.bottomAnchor,constant: outerSpace),
            recommendationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendationView.bottomAnchor.constraint(equalTo: expectionalLabel.bottomAnchor),
            
            expectionalLabel.trailingAnchor.constraint(equalTo: recommendedLabel.leadingAnchor,constant: -outerSpace*2),
            expectionalLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            
            recommendedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -outerSpace*2),
            recommendedLabel.topAnchor.constraint(equalTo: recommendationView.topAnchor,constant: innerSpace),
            
            mehLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor ,constant: outerSpace*2),
            mehLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            
            skipLabel.leadingAnchor.constraint(equalTo: mehLabel.trailingAnchor,constant: outerSpace*2),
            skipLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor)
        ])
    }
}

extension DetailVC: DetailViewModelDelegate {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in}
    }
    
    
}
