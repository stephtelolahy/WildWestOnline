//
//  Setup.swift
//
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func buildGame(
        figures: [Card],
        defaultAttributes: Attributes,
        defaultAbilities: [String],
        deck: [String]
    ) -> GameState {
        let figures = figures
        var deck = deck.shuffled()
        let players: [Player] = figures.map { figure in
            let identifier = figure.name
            
            var attributes: Attributes = .init()
            attributes.merge(defaultAttributes) { _, new in new }
            attributes.merge(figure.attributes) { _, new in new }

            let abilities = defaultAbilities + [figure.name]

            guard let health = attributes[.maxHealth] else {
                fatalError("missing attribute maxHealth")
            }

            let handCards: [String] = Array(1...health).map { _ in deck.removeFirst() }
            let hand = CardLocation(cards: handCards, visibility: identifier)

            return Player(
                id: identifier,
                name: identifier,
                startAttributes: attributes,
                attributes: attributes,
                abilities: abilities,
                health: health,
                hand: hand,
                inPlay: .init()
            )
        }

        var state = GameState()
        for player in players {
            state.players[player.id] = player
            state.startOrder.append(player.id)
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
