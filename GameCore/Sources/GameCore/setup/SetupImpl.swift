//
//  RuleSetupImpl.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

public struct SetupImpl: Setup {
    
    public init() {}
    
    public func createGame(playersCount: Int, deck: [Card], abilities: [Card], figures: [Card]) -> Game {
        var deck = deck.shuffled()
        let figures = figures.shuffled()
        var players: [String: Player] = [:]
        var playOrder: [String] = []
        let identifiableAbilities = abilities.map { $0.withId($0.name) }
        
        Array(0..<playersCount).forEach { index in
            let name = figures[index].name
            let health = 4
            
            let hand: [Card] = Array(1...health).map { _ in deck.removeFirst() }
            let player = PlayerImpl(name: name,
                                    maxHealth: health,
                                    health: health,
                                    abilities: identifiableAbilities,
                                    hand: hand)
            players[name] = player
            playOrder.append(name)
        }
        
        return GameImpl(players: players,
                        playOrder: playOrder,
                        deck: deck)
    }
    
    public func starting(_ ctx: Game) -> [Event] {
        guard ctx.turn == nil else {
            return []
        }
        
        let playerId = ctx.playOrder[0]
        return [SetTurn(player: PlayerId(playerId))]
    }
}
