//
//  SearchResultVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

class SearchResultVC: UICollectionViewController {
    
    var searchViewModel: SearchResultVM!
    var searchInfoView: SearchReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel.infoHandler = self
        configıreCollectionView()
    }
    
    private func configıreCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
        collectionView.register(SearchReusableView.self, forSupplementaryViewOfKind: SearchReusableView.elementKind, withReuseIdentifier: SearchReusableView.reuseIdentifier)
    }
}
//MARK: - SearhController Delegate
extension SearchResultVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let strippedString = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces), !strippedString.isEmpty else { return }
        searchViewModel.performSearch(with: strippedString)
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        searchViewModel.resetSearchResult()
    }
    
}
//MARK: - Search Reusable Info
extension SearchResultVC: SearchResultVMInformationHandler {
    func presentSerachActivity() {
        guard let searchInfoView = searchInfoView else { return }
        searchInfoView.presentActivityIndicator()
    }
    
    func presentSearchResult(with count: Int) {
        guard let searchInfoView = searchInfoView else { return }
        searchInfoView.presentInformation(count: count)
    }
}
