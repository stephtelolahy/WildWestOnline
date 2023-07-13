//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 11/07/2023.
//
import Game

public enum Inventory {
    public static func createGame(playersCount: Int) -> GameState {
        let abilities: [String] = [
            .endTurn,
            .drawOnSetTurn,
            .eliminateOnLooseLastHealth,
            .gameOverOnEliminated,
            .discardCardsOnEliminated,
            .nextTurnOnEliminated
        ]
        let allFigures: [Figure] = [
            .init(name: .willyTheKid, bullets: 4),
            .init(name: .roseDoolan, bullets: 4),
            .init(name: .paulRegret, bullets: 4),
            .init(name: .jourdonnais, bullets: 4),
            .init(name: .slabTheKiller, bullets: 4),
            .init(name: .luckyDuke, bullets: 4),
            .init(name: .calamityJanet, bullets: 4),
            .init(name: .bartCassidy, bullets: 4),
            .init(name: .elGringo, bullets: 4),
            .init(name: .suzyLafayette, bullets: 4),
            .init(name: .vultureSam, bullets: 4),
            .init(name: .sidKetchum, bullets: 4),
            .init(name: .blackJack, bullets: 4),
            .init(name: .kitCarlson, bullets: 4),
            .init(name: .jesseJones, bullets: 4),
            .init(name: .pedroRamirez, bullets: 4)
        ]
        let figures = Array(allFigures.shuffled().prefix(playersCount))
        let deck = Setup.createDeck(cardSets: CardSets.bang)
        
        let game = Setup.createGame(figures: figures,
                                    abilities: abilities,
                                    deck: deck)
            .cardRef(CardList.all)
        
        return game
    }
}
