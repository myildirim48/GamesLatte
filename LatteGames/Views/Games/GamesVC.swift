//
//  GamesVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

class GamesVC: UICollectionViewController {
    
    private let environment: Environment!
    private var gamesViewModel: GamesVM!
    
    private var searchViewModel : SearchResultVM!
    var searchController: UISearchController!
    var searchResultVC: SearchResultVC!
    
    
    
    private var dataSource : GamesDataSource?
    
    required init?(coder:NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        super.init(coder: coder)
        self.gamesViewModel = GamesVM(environment: environment)
    }
    
    required init(environemnt: Environment, layout: UICollectionViewLayout) {
        self.environment = environemnt
        super.init(collectionViewLayout: layout)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gamesViewModel = GamesVM(environment: environment)
        searchViewModel = SearchResultVM(environment: environment)
        
        configureCollectionView()
        configureSearch()
        
        dataSource = configureDataSource(for: collectionView)
        gamesViewModel.dataSource = dataSource
        gamesViewModel.errorHandler = self
        
        let searchDataSource = configureDataSource(for: searchResultVC.collectionView)
        searchViewModel.configureDataSource(with: searchDataSource)
        searchViewModel.errorHandler = self
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
        collectionView.register(TitleReusableView.self, forSupplementaryViewOfKind: TitleReusableView.elementKind, withReuseIdentifier: TitleReusableView.reuseIdentifier)
    }
    
    private func configureSearch(){
        searchResultVC = SearchResultVC(collectionViewLayout: UICollectionViewLayoutGenerator.generateLayoutForStyle(.search))
        searchResultVC.searchViewModel = searchViewModel
        searchResultVC.collectionView.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchResultsUpdater = searchResultVC
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a game.."
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
}
//MARK: - ColletionView Delegate
extension GamesVC {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            
            guard let currentSection = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch currentSection {
            case .alltimeBest:
                gamesViewModel.pagination(section: .alltimeBest, index: indexPath.item)
            case .alltimeBestMultiplayer:
                gamesViewModel.pagination(section: .alltimeBestMultiplayer, index: indexPath.item)
            case .lastyearPopular:
                gamesViewModel.pagination(section: .lastyearPopular, index: indexPath.item)
            case .lastmonthReleased:
                gamesViewModel.pagination(section: .lastmonthReleased, index: indexPath.item)
                
            }
        case searchResultVC.collectionView:
            searchViewModel.shouldFetchData(index: indexPath.item)
        default:
            return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedGameID = gamesViewModel.item(for: indexPath)
        
        let detailVC = DetailVC(environemnt: environment)
        detailVC.selectedGameID = selectedGameID?.id
        detailVC.selectedDisplableResource = selectedGameID
        detailVC.delegate = self
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}
//MARK: - Configure Data Source
extension GamesVC {
    private func configureDataSource(for collectionView: UICollectionView) -> GamesDataSource {
        
        let datasource = GamesDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseId, for: indexPath) as! GameCell
            cell.favoritesButton.isSelected = self.environment.store.viewContext.hasPersistenceId(for: itemIdentifier)
            cell.gameData = itemIdentifier
            cell.delegate = self
            return cell
        }
        
        datasource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case TitleReusableView.elementKind:
            
                let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleReusableView.reuseIdentifier, for: indexPath) as! TitleReusableView
                let section = UICollectionViewLayoutGenerator.ResourceSection(rawValue: indexPath.section)!
                titleSupplementary.label.text = section.sectionTitle
                return titleSupplementary
                
            case SearchReusableView.elementKind:
                let searchSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchReusableView.reuseIdentifier, for: indexPath) as! SearchReusableView
                self.searchResultVC.searchInfoView = searchSupplementary
                return searchSupplementary
            default:
             return nil
            }
          
        }
        return datasource
    }
}
//MARK: - Error Handlers
extension GamesVC : GamesViewModelDelegate,SearchResultVMErrorHandler {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in }
    }
}

//MARK: - HeroCell Delegate
extension GamesVC : GameCellDelegate {
    func gameCellFavoriteButtonTapped(cell: GameCell) {
        guard let game = cell.gameData else { return }
        let imageData = cell.imageView.image?.pngData()
        environment.store.toggleStorage(for: game, with: imageData,completion: {_ in})
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - GameDetail Delegate
extension GamesVC: DetailVCDelegate{
    func favoriteListUpdated() {
        print("pompik")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


