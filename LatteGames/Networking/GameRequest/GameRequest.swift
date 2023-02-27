//
//  GameRequest.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol Request {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    func composeRequest(with data: RequestDataType) throws -> URLRequest
    func parse(data:Data?) throws -> ResponseDataType
}

struct GameRequest<A:Codable>: Request{
    
    typealias ResponseDataType = NetworkResponse<A>
    
    enum Path {
        case base
        case detail(String)
        case screenShots(String)
        
        var string: String {
            switch self {
            case .base: return "/api/games"
            case .detail(let id): return "/api/games/\(id)"
            case .screenShots(let id): return "/api/games/\(id)/screenshots"
            }
        }
    }
    
    let baseURL: URL
    let path: Path
    let auth: [Query]?
    
    init(_ baseURL: URL, path: Path, auth: [Query]?) {
        self.baseURL = baseURL
        self.path = path
        self.auth = auth
    }
    
    func composeRequest(with paramaters: [Query] = []) throws -> URLRequest {
        let queryItems = auth == nil ? paramaters : paramaters + auth!
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = path.string
        components.queryItems = queryItems.toItems()
        return URLRequest(url: components.url!)
    }
    
    func parse(data: Data?) throws -> ResponseDataType {
        return try JSONDecoder().decode(ResponseDataType.self, from: data!)
    }
}

