//
//  Setup.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//

/// Creating a game
public enum Setup {
    
    public static func buildGame(playersCount: Int, deck: [Card], inner: [Card]) -> State {
        var deck = deck.shuffled()
        var players: [String: Player] = [:]
        var playOrder: [String] = []
        Array(1...playersCount).forEach { index in
            let id = "p\(index)"
            let health = 4
            let hand: [Card] = Array(1...health).map { _ in deck.removeFirst() }
            let inner: [Card] = inner.map {
                var copy = $0
                copy.id = $0.name
                return copy
            }
            let player = Player(name: id,
                                maxHealth: health,
                                health: health,
                                inner: inner,
                                hand: hand)
            players[id] = player
            playOrder.append(id)
        }
        
        return State(players: players,
                     playOrder: playOrder,
                     turn: playOrder.first,
                     phase: 1,
                     deck: deck)
    }
}
