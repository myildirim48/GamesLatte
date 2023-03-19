//
//  StateChangeMessage.swift
//  LatteGames
//
//  Created by YILDIRIM on 19.03.2023.
//

import Foundation
struct StateChangeMessage {
    let state: State
    let title: String
    let message: String
    let game: DisplayableResource
}

extension StateChangeMessage {
    enum State { case memory,persisted }
    
    static func deleteGame(_ state: State = .memory, with game: DisplayableResource) -> StateChangeMessage{
        StateChangeMessage(state: state, title: "Deleting \(game.name!) ? ", message: "Are you sure to delete this game from favorites ? ", game: game)
    }
}
