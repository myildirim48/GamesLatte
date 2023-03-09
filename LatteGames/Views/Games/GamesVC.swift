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
        
//        let dataSource = configureDataSource(for: collectionView)
        dataSource = configureDataSource(for: collectionView)
        gamesViewModel.dataSource = dataSource
        gamesViewModel.errorHandler = self
        
        let searchDataSource = configureDataSource(for: searchResultVC.collectionView)
        searchViewModel.configureDataSource(with: searchDataSource)
        searchViewModel.errorHandler = self
        
    }
    
    private func configureCollectionView(){
//        view.addSubview(collectionView)
//        collectionView.setCollectionViewLayout(UICollectionViewLayoutGenerator.resourcesCollectionViewLayout(), animated: false)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
        collectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: LoaderReusableView.elementKind, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
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
            
            //TODO -> Pagination
            
            guard let currentSection = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return }
            
            switch currentSection {
            case .alltimeBest:
//                gamesViewModel.gameRequestManager.fetchAllTime()
                print("Alltime best")
                return
            case .alltimeBestMultiplayer:
                print("Alltime best multiplayer")
            case .lastyearPopular:
                print("Last year popular")
            case .lastmonthReleased:
                print("Last month Released")
                
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
        detailVC.selectedGameID = selectedGameID
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}
//MARK: - Configure Data Source
extension GamesVC {
    private func configureDataSource(for collectionView: UICollectionView) -> GamesDataSource {
        
        let datasource = GamesDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseId, for: indexPath) as! GameCell
            cell.gameData = itemIdentifier
            return cell
        }
        
        datasource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case LoaderReusableView.elementKind:
            
                let loaderSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderReusableView.reuseIdentifier, for: indexPath) as! LoaderReusableView
                return loaderSupplementary
            
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

extension GamesVC : GamesViewModelDelegate,SearchResultVMErrorHandler {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in }
    }
}
