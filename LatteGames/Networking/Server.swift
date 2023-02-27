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
    
    init(baseURL: URL = URL(string: "https://gateway.marvel.com")!) {
        self.baseURL = baseURL
        self.auth = Auth()
    }
    
    private func authQueryItems() -> [Query] {
        let parameters = [auth.baseKey()]
        return parameters
    }
    
//    private func fetchByTagsQuery(tag:String) -> [Query] {
//        var parameter = authQueryItems()
//        parameter.append(.tags(tag))
//        return parameter
//    }
//    
    
    
    //MARK: - Game Requests
    
    /// Games Request for AllTimeBest
    /// - Parameter : All games
    /// - Returns: Authenticated request with matching Character type
    func gameAllRequest() throws -> GameRequest<GameDataModelResult>{
        return GameRequest(baseURL, path: .base, auth: authQueryItems())
    }
    
    /// Games Request for AllTimeBest
    /// - Parameter : All games
    /// - Returns: Authenticated request with matching Character type
//    func requestbyTags(tag:String) throws -> GameRequest<GameDataModelResult>{
//        return GameRequest(baseURL, path: .base, auth: fetchByTagsQuery(tag: tag))
//    }
    
    
    //TODO -> FOR OTHER 4 AND DETAILS
}
extension Server {
    
    struct Auth {
        func baseKey() -> Query {
            return .apikey()
        }

    }

}
