//
//  Server.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
class Server {
    enum ServerError: Error, Equatable {
        case Unauthenticated(String)
    }
    
    typealias Keys = (public: String, private: String)?
    
    public var baseURL: URL
    
    private var auth: Auth
    
    init(baseURL: URL = URL(string: "https://api.rawg.io")!) {
        self.baseURL = baseURL
        self.auth = Auth()
    }
    
    private func authQueryItems() -> [Query] {
        let parameters = [auth.baseKey()]
        return parameters
    }
    
    //MARK: - Game Requests
    
    /// Games Request for Games
    /// - Parameter : All games by rating
    /// - Returns: Authenticated request with matching GameDataModelResult type
    func gameAllRequest() throws -> GameRequest<GameDataModelResult>{
        return GameRequest(baseURL, path: .base, auth: authQueryItems())
    }
    
    /// Games Request for Game Detail
    /// - Parameter id: Game id for details
    /// - Returns: Authenticated request with matching GameDetail type
    func fetchGameDetail(id: Int) throws -> GameRequest<GameDetail>{
        return GameRequest(baseURL, path: .detail(String(id)), auth: authQueryItems())
    }
    
    
}
extension Server {
    struct Auth {
        func baseKey() -> Query {
            return .apikey()
        }
    }
}
