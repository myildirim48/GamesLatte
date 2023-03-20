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
    var selectedDisplableResource: DisplayableResource? {
        didSet {
            guard let selectedDispRes = selectedDisplableResource else { return }
            favoriteButton.isSelected = self.environment.store.viewContext.hasPersistenceId(for:selectedDispRes)
        }
    }
    
    private let environment: Environment!
    private var detailVM: DetailVM!
    
    let gameImageView = LatteImageView(frame: .zero)
    let nameLabel = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let publishersLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel)
    let genresLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let descriptionLabel = LatteLabel(textAligment: .left, font: .init(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 14))
    
    let favoriteButton = FavoriteButton(frame: .zero)

    
    let ratingLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(0.75))
    let ratingLabelImage = LatteImageView(systemImageName: "star.fill",tintColor: .systemYellow)
    let releasedDateLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(0.75))
    let releasedDateLabelImage = LatteImageView(systemImageName: "calendar.badge.plus",tintColor: .systemGreen)
    let playtimeLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(0.75))
    let playtimeImage = LatteImageView(systemImageName: "clock.badge.checkmark",tintColor: .systemBlue)
    let homePageImage = LatteImageView(systemImageName: "network",tintColor: .systemMint)
    let homePagelabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,text: "HomePage Website", textColor: .secondaryLabel.withAlphaComponent(0.75))
    let playablePlatformImage = LatteImageView(systemImageName: "gamecontroller.fill",tintColor: .systemIndigo)
    let playableLabel = LatteLabel(textAligment: .left, font: Theme.fonts.desriptionFont,textColor: .secondaryLabel.withAlphaComponent(0.75))
    
    let recommendationView = UIView()
    var imageCollectionView : UICollectionView!
    let contenView = UIView()
    let scrollView = UIScrollView()
    let expectionalLabel = RatingInfoView()
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
        configureScrollView()
        configureCollectionView()
        configure()
        configureDoneButton()
        
        let dataSource = generateDatasource()
        detailVM.dataSource = dataSource
        
        guard let gameID = selectedGameID else { return }
        detailVM.delegate = self
        detailVM.configure(gameID: gameID)
        detailVM.gameDetailsVoid = { data in
            self.update(with: data)
            self.selectedGame = data
        }
    }
    
    @objc func favoritesButtonTapped(_ sender: UIButton){
        guard let game = selectedDisplableResource else { return }
        if favoriteButton.isSelected == false {
            presentAlertWithStateChange(message: .deleteGame(with: game)) {_ in
                guard let environment = self.environment else { return }
                 environment.store.toggleStorage(for: game, completion: {_ in})
            }
        }else {
            let imageData = gameImageView.image?.pngData()
            environment.store.toggleStorage(for: game, with: imageData,completion: {_ in})
        }
        
    }
    
    private func update(with selectedGame: GameDetail?){
        guard let selectedGame = selectedGame else {
            return
        }
        
        Task { self.gameImageView.image = await ImageFetcher.shared.downloadImage(from: selectedGame.backgroundImage ?? "" )}
        
        title = selectedGame.name
        nameLabel.text = selectedGame.name
        publishersLabel.text = selectedGame.publishers.map({ $0.name }).joined(separator: ", ")
        genresLabel.text = selectedGame.genres.map({ $0.name ?? " " }).joined(separator: ", ")
        
        releasedDateLabel.text = selectedGame.released.transformStringToDate().dateToString()
        ratingLabel.text = "\(selectedGame.rating ?? 0.0) / 5"
        playtimeLabel.text = "\(selectedGame.playtime) Hours Played."
        descriptionLabel.text = selectedGame.descriptionRaw
        playableLabel.text = selectedGame.parentPlatforms.map({ $0.platform.name}).joined(separator: ", ")
        
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

        configureWebsiteLink()
    }
    
    
     func configureWebsiteLink(){
         homePagelabel.isUserInteractionEnabled = true
         let tapLabel = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        homePagelabel.addGestureRecognizer(tapLabel)
    }
    
    @objc func labelTapped(sender:UITapGestureRecognizer){
        guard let url = URL(string: selectedGame?.website ?? "") else {
            presentDefaultAlert()
            return
        }
        presentSafariVC(with: url)
    }
    
    private func configureCollectionView(){
        imageCollectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewLayoutGenerator.generateLayoutForStyle(.paginated))
        imageCollectionView.register(ScreenShotsCell.self, forCellWithReuseIdentifier: ScreenShotsCell.reuseId)
        imageCollectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: LoaderReusableView.elementKind, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
    }
    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contenView)
        scrollView.pinToEdges(of: view)
        contenView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contenView.heightAnchor.constraint(equalToConstant: 1000)
            
        ])
    }
    
    private func configureDoneButton(){
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    #warning("here is hard coded")
    private func configure(){
        
        favoriteButton.addTarget(self, action: #selector(self.favoritesButtonTapped(_:)), for: .touchUpInside)
        
        contenView.addSubviews(gameImageView,nameLabel,genresLabel,ratingLabel,ratingLabelImage,releasedDateLabel,releasedDateLabelImage,publishersLabel,playtimeImage,playtimeLabel,favoriteButton,recommendationView,homePageImage,homePagelabel,descriptionLabel,playableLabel,playablePlatformImage,imageCollectionView)
        
        recommendationView.addSubviews(expectionalLabel,recommendedLabel,mehLabel,skipLabel)
        
        let innerSpace:CGFloat = 5
        let outerSpace:CGFloat = 20
        
        view.backgroundColor = .systemBackground
        gameImageView.layer.cornerRadius = 10
        
        recommendationView.translatesAutoresizingMaskIntoConstraints = false
        recommendationView.layer.borderWidth = 1
        recommendationView.layer.borderColor = UIColor.systemGray6.cgColor
    
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            gameImageView.topAnchor.constraint(equalTo: contenView.topAnchor,constant: outerSpace),
            gameImageView.leadingAnchor.constraint(equalTo: contenView.leadingAnchor,constant: outerSpace),
            gameImageView.heightAnchor.constraint(equalToConstant: 200),
            gameImageView.widthAnchor.constraint(equalToConstant: 130),
            
            nameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor,constant: innerSpace),
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace*2),
            nameLabel.trailingAnchor.constraint(equalTo: contenView.trailingAnchor,constant: -outerSpace),
            
            publishersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpace),
            publishersLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            publishersLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            genresLabel.topAnchor.constraint(equalTo: publishersLabel.bottomAnchor,constant: innerSpace),
            genresLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            releasedDateLabelImage.topAnchor.constraint(equalTo: genresLabel.bottomAnchor,constant: outerSpace),
            releasedDateLabelImage.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor,constant: innerSpace*2),
            
            releasedDateLabel.centerYAnchor.constraint(equalTo: releasedDateLabelImage.centerYAnchor),
            releasedDateLabel.leadingAnchor.constraint(equalTo: releasedDateLabelImage.trailingAnchor,constant: innerSpace),
            
            ratingLabelImage.topAnchor.constraint(equalTo: releasedDateLabel.bottomAnchor,constant: innerSpace),
            ratingLabelImage.centerXAnchor.constraint(equalTo: releasedDateLabelImage.centerXAnchor),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingLabelImage.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingLabelImage.trailingAnchor,constant: innerSpace),
            
            favoriteButton.centerYAnchor.constraint(equalTo: ratingLabelImage.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contenView.trailingAnchor,constant: -outerSpace*2),
            
            
            playtimeImage.topAnchor.constraint(equalTo: ratingLabelImage.bottomAnchor,constant: innerSpace),
            playtimeImage.centerXAnchor.constraint(equalTo: ratingLabelImage.centerXAnchor),
            
            playtimeLabel.centerYAnchor.constraint(equalTo: playtimeImage.centerYAnchor),
            playtimeLabel.leadingAnchor.constraint(equalTo: playtimeImage.trailingAnchor,constant: innerSpace),
            
            homePageImage.topAnchor.constraint(equalTo: playtimeLabel.bottomAnchor,constant: innerSpace),
            homePageImage.centerXAnchor.constraint(equalTo: ratingLabelImage.centerXAnchor),
            
            homePagelabel.centerYAnchor.constraint(equalTo: homePageImage.centerYAnchor),
            homePagelabel.leadingAnchor.constraint(equalTo: homePageImage.trailingAnchor,constant: innerSpace),
            
            playablePlatformImage.topAnchor.constraint(equalTo: homePagelabel.bottomAnchor,constant: innerSpace),
            playablePlatformImage.centerXAnchor.constraint(equalTo: ratingLabelImage.centerXAnchor),
            
            playableLabel.centerYAnchor.constraint(equalTo: playablePlatformImage.centerYAnchor),
            playableLabel.leadingAnchor.constraint(equalTo: playablePlatformImage.trailingAnchor,constant: innerSpace),
            
            recommendationView.topAnchor.constraint(equalTo: gameImageView.bottomAnchor,constant: outerSpace),
            recommendationView.leadingAnchor.constraint(equalTo: contenView.leadingAnchor),
            recommendationView.trailingAnchor.constraint(equalTo: contenView.trailingAnchor),
            recommendationView.bottomAnchor.constraint(equalTo: expectionalLabel.bottomAnchor),
            
            expectionalLabel.trailingAnchor.constraint(equalTo: recommendedLabel.leadingAnchor,constant: -outerSpace*2),
            expectionalLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            
            recommendedLabel.centerXAnchor.constraint(equalTo: contenView.centerXAnchor,constant: -outerSpace*2),
            recommendedLabel.topAnchor.constraint(equalTo: recommendationView.topAnchor,constant: innerSpace),
            
            mehLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor ,constant: outerSpace*2),
            mehLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            
            skipLabel.leadingAnchor.constraint(equalTo: mehLabel.trailingAnchor,constant: outerSpace*2),
            skipLabel.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: recommendationView.bottomAnchor,constant: outerSpace),
            descriptionLabel.leadingAnchor.constraint(equalTo: recommendationView.leadingAnchor,constant: outerSpace),
            descriptionLabel.trailingAnchor.constraint(equalTo: recommendationView.trailingAnchor,constant: -outerSpace),
            
            imageCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: outerSpace),
            imageCollectionView.leadingAnchor.constraint(equalTo: contenView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contenView.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: contenView.bottomAnchor)
        ])
    }
}
//MARK: - Data Source Generator

extension DetailVC {
    public func generateDatasource() -> GamesImagesDataSource {
        
        let dataSource = GamesImagesDataSource(collectionView: imageCollectionView, cellProvider: { (collectionView, indexPath, gameScreenShot) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenShotsCell.reuseId, for: indexPath) as! ScreenShotsCell
            Task {
                cell.imageView.image = await ImageFetcher.shared.downloadImage(from: gameScreenShot.image )
                cell.activityIndicator.stopAnimating()
            }
            return cell
        })
        
        dataSource.supplementaryViewProvider =  {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let loaderSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderReusableView.reuseIdentifier, for: indexPath) as! LoaderReusableView
            return loaderSupplementary
        }
        return dataSource
    }
}

//MARK: - Error Handler
extension DetailVC: DetailViewModelDelegate {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in}
    }

//    func viewModelDidTogglePersistence(with status: Bool) {
//        animateFavoriteButtonSelection()
//    }
//
//    func animateFavoriteButtonSelection(){
//        UIView.transition(with: favoriteButton, duration: 0.25,options: .transitionCrossDissolve) {
//            self.favoriteButton.isSelected = !self.favoriteButton.isSelected
//        }
//    }
//    
//    func presentPersistanceAlert() {
//        
//    }
}
