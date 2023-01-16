//
//  RuleSetupImpl.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

extension Rules: RuleSetup {
    
    public func createGame(playersCount: Int, deck: [Card], abilities: [Card]) -> Game {
        var deck = deck.shuffled()
        var players: [String: Player] = [:]
        var playOrder: [String] = []
        let identifiableAbilities = abilities.map { $0.withId($0.name) }
        
        Array(1...playersCount).forEach { index in
            // TODO: add figure
            let id = "p\(index)"
            let health = 4
            
            let hand: [Card] = Array(1...health).map { _ in deck.removeFirst() }
            let player = PlayerImpl(name: id,
                                    maxHealth: health,
                                    health: health,
                                    abilities: identifiableAbilities,
                                    hand: hand)
            players[id] = player
            playOrder.append(id)
        }
        
        return GameImpl(players: players,
                        playOrder: playOrder,
                        deck: deck)
    }
}
