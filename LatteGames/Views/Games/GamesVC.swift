//
//  GamesVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

class GamesVC: UICollectionViewController {
    
    private let environment: Environment!
    private var dataSource: GamesDataSource?
    private var gamesViewModel: GamesVM!
    
//    private var searchResultVM : SearchResultVM!
//    var searchController: UISearchController!
//    var searchResultVC: SearchResultVC!
    
    required init?(coder:NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        super.init(coder: coder)
        self.gamesViewModel = GamesVM(environment: environment)
    }
    
    required init(environemnt: Environment, layout: UICollectionViewLayout) {
        self.environment = environemnt
        super.init(collectionViewLayout: layout)
        self.gamesViewModel = GamesVM(environment: environment)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        gamesViewModel.delegate = self
        let dataSource = configureDataSource()
        gamesViewModel.dataSource = dataSource
        
        
    }
    
    private func configureCollectionView(){
//        view.addSubview(collectionView)
        collectionView.setCollectionViewLayout(UICollectionViewLayoutGenerator.resourcesCollectionViewLayout(), animated: false)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
        collectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: LoaderReusableView.elementKind, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
        collectionView.register(TitleReusableView.self, forSupplementaryViewOfKind: TitleReusableView.elementKind, withReuseIdentifier: TitleReusableView.reuseIdentifier)
    }
}

extension GamesVC {
    private func configureDataSource() -> GamesDataSource {
        let datasource = GamesDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseId, for: indexPath) as! GameCell
            cell.gameData = itemIdentifier
            return cell
        }
        
        datasource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleReusableView.reuseIdentifier, for: indexPath) as! TitleReusableView
            
            let section = UICollectionViewLayoutGenerator.ResourceSection(rawValue: indexPath.section)!
            titleSupplementary.label.text = section.sectionTitle
            
            return titleSupplementary
        }
        return datasource
    }
}

extension GamesVC : GamesViewModelDelegate {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in }
    }
}
