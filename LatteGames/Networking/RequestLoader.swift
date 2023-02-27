//
//  RequestLoader.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation

struct ServerSideError: Error, Equatable {
    public let statusCode: Int
    public let response: HTTPURLResponse?
    public init(statusCode: Int, response: HTTPURLResponse?) {
        self.statusCode = statusCode
        self.response = response
    }
}

enum RequestLoaderError: Error {
    case Transport(Error)
    case ServerSide(ServerSideError)
    case Decoding(Error)
    case RequestCompose(Error)
    case Network(Error?)
}

class RequestLoader<T: Request>{
    let request : T
    let session : URLSession
    
    init(request: T, session: URLSession = .shared) {
        self.request = request
        self.session = session
    }
    
    func load(data: T.RequestDataType, onComplete: @escaping(Result<T.ResponseDataType, RequestLoaderError>) -> Void) {
        do {
            let req = try request.composeRequest(with: data)
            session.dataTask(with: req) { data, response, error in
                print(req.url)
                if let error = error {
                    onComplete(.failure(RequestLoaderError.Transport(error)))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(.failure(RequestLoaderError.Network(error)))
                    return
                }
                
                let status = response.statusCode
                guard self.expected200to300(status) else {
                    onComplete(.failure(RequestLoaderError.ServerSide(ServerSideError(statusCode: status, response: response))))
                    return
                }
                
                do{
                    let parseData = try self.request.parse(data: data)
                    onComplete(.success(parseData))
                }catch{
                    onComplete(.failure(RequestLoaderError.Decoding(error)))
                }
            }.resume()
        }catch {
            return onComplete(.failure(RequestLoaderError.RequestCompose(error)))
        }
    }
    
}

extension RequestLoader {
    private func expected200to300(_ code: Int) -> Bool {
        return code >= 200 && code < 300
    }
}

#warning("Why here is equatable")
extension RequestLoaderError: Equatable {
    static func == (lhs: RequestLoaderError, rhs: RequestLoaderError) -> Bool {
        switch (lhs, rhs) {
        case (.Transport, .Transport):
            return true
        case (.ServerSide, .ServerSide):
            return true
        case (.Decoding, .Decoding):
            return true
        default:
            return false
        }
    }
}
