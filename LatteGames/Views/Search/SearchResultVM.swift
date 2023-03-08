//
//  SearchResultVM.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol SearchResultVMErrorHandler:AnyObject {
    func viewModelDidRecieveError(error: UserFriendlyError)
}
protocol SearchResultVMInformationHandler:AnyObject {
    func presentSerachActivity()
    func presentSearchResult(with count:Int)
}

class SearchResultVM: NSObject {
    private enum State { case loading,ready }
    
    private let environment: Environment!
    private var state: State = .ready
    
    private var searcgRequest : GameRequest<NetworkResponse<GameDataModelResult>>!
    
    private var searchRequestLoader : RequestLoader<GameRequest<NetworkResponse<GameDataModelResult>>>!
    private let debouncer : Debouncer = Debouncer(minimumDelay: 0.5)
    
    private var currentSearchResult : SearchResult?
    private var searchDataSource: SearchDataSource?
    
    weak var errorHandler: SearchResultVMErrorHandler?
    weak var infoHandler: SearchResultVMInformationHandler?
    
    init(environment: Environment) {
        self.environment = environment
        self.searcgRequest = try? environment.server.gameAllRequest()
        super.init()
        searchRequestLoader = RequestLoader(request: searcgRequest)
    }
    
    func configureDataSource(with dataSource: SearchDataSource){
        searchDataSource = dataSource
        configureDataSource()
    }
    
    //MARK: - Pagination
    private let defaultPageSize = 20
    private let defaultPrefetchBuffer = 1
    
    func requestOffsetForInput(_ text: String) -> Int{
        guard let cs = currentSearchResult, text == cs.query.input.value else {
            return 0
        }
        
        let currentPage = Int(cs.query.page.value)!
        let newPage = currentPage + 1
        return newPage >= cs.total ? currentPage : newPage
    }
    
    func composeNextPageSearchQuery() -> SearchQuery? {
        guard let csi = currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(page:.page(page: requestOffsetForInput(csi).toString()), input: .search(csi))
        guard searchQuery != currentSearchResult?.query else { return nil }
        return searchQuery
    }
    
    func composeSearchQuery(with text: String) -> SearchQuery? {
        guard text != currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(page: .page(page: requestOffsetForInput(text).toString()), input: .search(text))
        guard searchQuery != currentSearchResult?.query else { return nil}
        return searchQuery
    }
    //MARK: - Data Fetch
    
    func performSearch(with text: String){
        debouncer.debounce { [unowned self] in
            guard let newSearchQuery = self.composeSearchQuery(with: text) else { return }
            
            self.infoHandler?.presentSerachActivity()
            self.requestWithQuery(searchQuery: newSearchQuery)
        }
    }
    
    func requestWithQuery(searchQuery: SearchQuery) {
        state = .loading
        
        self.searchRequestLoader.load(data: [searchQuery.page,searchQuery.input]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let count = response.count, let result = response.results else { return }
                self.updateSearchResult(with: SearchResult(total: count, query: searchQuery), data: result)
            case .failure(let error):
                self.state = .ready
                self.errorHandler?.viewModelDidRecieveError(error: .userFriendlyError(error))
            }
        }
    }
    
    func shouldFetchData(index:Int){
        guard let dataSource = searchDataSource else { return }
        let currentSnapshot = dataSource.snapshot()
        
        guard currentSnapshot.numberOfItems == (index + defaultPrefetchBuffer)
                && state == .ready,
                let searchQuery = composeNextPageSearchQuery() else { return }
        requestWithQuery(searchQuery: searchQuery)
    }
    
    //MARK: - Data Source
    func item(for indexPath: IndexPath) -> GameDataModelResult? {
        searchDataSource?.itemIdentifier(for: indexPath)
    }
    
    func updateSearchResult(with result: SearchResult, data: [GameDataModelResult]){
        guard let dataSource = searchDataSource else { return  }
        state = .ready
        
        var currentSnapshot = dataSource.snapshot()
        if result.query.input == currentSearchResult?.query.input{
            currentSnapshot.appendItems(data,toSection: .main)
        }else if !data.isEmpty {
            currentSnapshot = SearchSnapshot()
            currentSnapshot.appendSections([.main])
            currentSnapshot.appendItems(data)
        }
        
        currentSearchResult = result
        updateSearchResultLabel(result.total)
        apply(currentSnapshot)
        
    }
    
    private func reloadDataSource(with character: GameDataModelResult){
        guard let dataSource = searchDataSource else { return }
        
        defer { state = .ready }
        
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.contains(character){
            snapshot.reloadItems([character])
            apply(snapshot)
        }
    }
    
    
    private func apply(_ changes: SearchSnapshot ,animating:Bool = true){
        DispatchQueue.main.async {
            self.searchDataSource?.apply(changes,animatingDifferences: animating)
        }
    }
    private func configureDataSource(){
        var initialSnapShot = SearchSnapshot()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems([],toSection: .main)
        apply(initialSnapShot,animating: false)
    }
    
    //MARK: - UI
    func updateSearchResultLabel(_ count: Int? = nil){
        self.infoHandler?.presentSearchResult(with: count ?? 0)
    }
    //MARK: - Reset state
    func resetSearchResult() {
        currentSearchResult = nil
    }
    
}

//MARK: - Helper Structures

extension SearchResultVM {
    struct SearchQuery:Equatable {
        let page: Query
        let input: Query
    }
    
    struct SearchResult{
        let total:Int
        let query:SearchQuery
    }
}
