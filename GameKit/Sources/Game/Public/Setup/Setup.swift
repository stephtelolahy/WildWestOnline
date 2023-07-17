//
//  Setup.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func createGame(
        figures: [Figure],
        abilities: [String],
        deck: [String]
    ) -> GameState {
        let figures = figures
        var deck = deck.shuffled()
        let players: [Player] = figures.map { figure in
            let identifier = figure.name
            let health = figure.bullets
            let hand: [String] = Array(1...health).map { _ in deck.removeFirst() }
            var player = Player(identifier)
            player.name = figure.name
            player.hand = CardLocation(cards: hand, visibility: identifier)
            player.attributes[.maxHealth] = health
            player.attributes[.health] = health
            player.abilities = figure.abilities
            return player
        }

        var state = GameState()
        for player in players {
            state.players[player.id] = player
            state.setupOrder.append(player.id)
            state.playOrder.append(player.id)
        }
        state.abilities = abilities
        state.deck = CardStack(cards: deck)
        return state
    }

    public static func createDeck(cardSets: [String: [String]]) -> [String] {
        var result: [String] = []
        for (key, values) in cardSets {
            for value in values {
                result.append("\(key)-\(value)")
            }
        }
        return result
    }
}
