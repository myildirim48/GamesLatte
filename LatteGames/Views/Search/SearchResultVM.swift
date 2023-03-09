//
//  SearchResultVM.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol SearchResultVMErrorHandler:AnyObject {
    func viewModelDidReceiveError(error: UserFriendlyError)
}
protocol SearchResultVMInformationHandler: NSObject {
    func presentSearchActivity()
    func presentSearchResult(with count:Int)
}

class SearchResultVM: NSObject {
    private enum State { case loading,ready }
    
    private let environment: Environment!
    private var state: State = .ready
    
    private var searcgRequest : GameRequest<NetworkResponse<GameDataModelResult>>!
    
    private var searchRequestLoader : RequestLoader<GameRequest<NetworkResponse<GameDataModelResult>>>!
    private let debouncer : Debouncer = Debouncer(minimumDelay: 0.75)
    
    private var currentSearchResult : SearchResult?
    private var searchDataSource: GamesDataSource?
    
    weak var errorHandler: SearchResultVMErrorHandler?
    weak var infoHandler: SearchResultVMInformationHandler?
    
    init(environment: Environment) {
        self.environment = environment
        self.searcgRequest = try? environment.server.gameAllRequest()
        super.init()
        searchRequestLoader = RequestLoader(request: searcgRequest)
    }
    
    func configureDataSource(with dataSource: GamesDataSource){
        searchDataSource = dataSource
        configureDataSource()
    }
    
    //MARK: - Pagination
    private let defaultPageSize = 20
    private let defaultPrefetchBuffer = 1
    
    func requestOffsetForInput(_ text: String) -> Int{
        guard let cs = currentSearchResult, text == cs.query.input.value else {
            return 1
        }
        
        let currentPage = Int(cs.query.page.value)!
        let newPage = currentPage + 1
        return newPage >= cs.total ? currentPage : newPage
    }
    
    func composeNextPageSearchQuery() -> SearchQuery? {
        guard let csi = currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(page:.page(page: requestOffsetForInput(csi).toString()), input: .search(csi), ordering: .ordering("-metacritic"))
        guard searchQuery != currentSearchResult?.query else { return nil }
        return searchQuery
    }
    
    func composeSearchQuery(with text: String) -> SearchQuery? {
        guard text != currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(page: .page(page: requestOffsetForInput(text).toString()), input: .search(text), ordering: .ordering("-metacritic"))
        guard searchQuery != currentSearchResult?.query else { return nil}
        return searchQuery
    }
    //MARK: - Data Fetch
    
    func performSearch(with text: String){
        debouncer.debounce { [unowned self] in
            guard let newSearchQuery = self.composeSearchQuery(with: text) else { return }
            
            self.infoHandler?.presentSearchActivity()
            self.requestWithQuery(searchQuery: newSearchQuery)
        }
    }
    
    func requestWithQuery(searchQuery: SearchQuery) {
        state = .loading
        
        self.searchRequestLoader.load(data: [searchQuery.page,searchQuery.input,searchQuery.ordering]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let count = response.count, let result = response.results?.toDisplayable(type: .alltimeBest) else { return }
                self.updateSearchResult(with: SearchResult(total: count, query: searchQuery), data: result)
            case .failure(let error):
                self.state = .ready
                self.errorHandler?.viewModelDidReceiveError(error: .userFriendlyError(error))
            }
        }
    }
    
    func shouldFetchData(index:Int){
        guard let dataSource = searchDataSource else { return }
        let currentSnapshot = dataSource.snapshot()
        
        guard currentSnapshot.numberOfItems == (index + defaultPrefetchBuffer) && state == .ready,
        let searchQuery = composeNextPageSearchQuery() else { return }
        
        requestWithQuery(searchQuery: searchQuery)
    }
    
    //MARK: - Data Source
    func item(for indexPath: IndexPath) -> DisplayableResource? {
        searchDataSource?.itemIdentifier(for: indexPath)
    }
    
    func updateSearchResult(with result: SearchResult, data: [DisplayableResource]){
        guard let dataSource = searchDataSource else { return  }
        state = .ready
        
        var currentSnapshot = dataSource.snapshot()
        if result.query.input == currentSearchResult?.query.input{
            currentSnapshot.appendItems(data)
        }else if !data.isEmpty {
            currentSnapshot = GamesSnapshot()
            currentSnapshot.appendSections([.lastyearPopular])
            currentSnapshot.appendItems(data)
        }
        
        currentSearchResult = result
        updateSearchResultLabel(result.total)
        apply(currentSnapshot)
        
    }
    
    private func reloadDataSource(with game: DisplayableResource){
        guard let dataSource = searchDataSource else { return }
        
        defer { state = .ready }
        
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.contains(game){
            snapshot.reloadItems([game])
            apply(snapshot)
        }
    }
    
    
    private func apply(_ changes: GamesSnapshot, animating:Bool = true){
        DispatchQueue.main.async {
            self.searchDataSource?.apply(changes,animatingDifferences: animating)
        }
    }
    private func configureDataSource(){
        var initialSnapShot = GamesSnapshot()
        initialSnapShot.appendSections([GamesDataSource.Section.lastyearPopular])
        initialSnapShot.appendItems([],toSection: .lastyearPopular)
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
        let ordering: Query
    }
    
    struct SearchResult{
        let total:Int
        let query:SearchQuery
        
    }
}
