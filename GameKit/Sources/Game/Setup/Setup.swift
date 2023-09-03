//
//  Setup.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func buildGame(
        figures: [Figure],
        attributes: Attributes,
        abilities: [String],
        deck: [String]
    ) -> GameState {
        let figures = figures
        var deck = deck.shuffled()
        let players: [Player] = figures.map { figure in
            let identifier = figure.name
            var player = Player(identifier)
            player.name = figure.name

            player.attributes.merge(attributes) { _, new in new }
            player.attributes.merge(figure.attributes) { _, new in new }
            player.abilities = abilities + figure.abilities

            guard let health = player.attributes[.maxHealth] else {
                fatalError("undefined max health")
            }

            player.attributes[.health] = health
            let hand: [String] = Array(1...health).map { _ in deck.removeFirst() }
            player.hand = CardLocation(cards: hand, visibility: identifier)

            return player
        }

        var state = GameState()
        for player in players {
            state.players[player.id] = player
            state.setupOrder.append(player.id)
            state.playOrder.append(player.id)
        }
        state.deck = CardStack(cards: deck)

        return state
    }

    public static func buildDeck(cardSets: [String: [String]]) -> [String] {
        var result: [String] = []
        for (key, values) in cardSets {
            for value in values {
                result.append("\(key)-\(value)")
            }
        }
        return result
    }
}
