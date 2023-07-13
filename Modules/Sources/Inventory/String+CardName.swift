//
//  String+CardName.swift
//  
//
//  Created by Hugues Telolahy on 12/04/2023.
//

public extension String {

    // MARK: - Collectible

    static let bang = "bang"
    static let missed = "missed"
    static let beer = "beer"
    static let saloon = "saloon"
    static let stagecoach = "stagecoach"
    static let wellsFargo = "wellsFargo"
    static let generalStore = "generalStore"
    static let catBalou = "catBalou"
    static let panic = "panic"
    static let gatling = "gatling"
    static let indians = "indians"
    static let duel = "duel"
    static let barrel = "barrel"
    static let dynamite = "dynamite"
    static let jail = "jail"
    static let mustang = "mustang"
    static let remington = "remington"
    static let revCarabine = "revCarabine"
    static let schofield = "schofield"
    static let scope = "scope"
    static let volcanic = "volcanic"
    static let winchester = "winchester"

    // MARK: - Figures

    static let willyTheKid = "willyTheKid"
    static let roseDoolan = "roseDoolan"
    static let paulRegret = "paulRegret"
    static let jourdonnais = "jourdonnais"
    static let slabTheKiller = "slabTheKiller"
    static let luckyDuke = "luckyDuke"
    static let calamityJanet = "calamityJanet"
    static let bartCassidy = "bartCassidy"
    static let elGringo = "elGringo"
    static let suzyLafayette = "suzyLafayette"
    static let vultureSam = "vultureSam"
    static let sidKetchum = "sidKetchum"
    static let blackJack = "blackJack"
    static let kitCarlson = "kitCarlson"
    static let jesseJones = "jesseJones"
    static let pedroRamirez = "pedroRamirez"

    // MARK: - Abilities
    
    static let endTurn = "endTurn"
    static let drawOnSetTurn = "drawOnSetTurn"
    static let eliminateOnLooseLastHealth = "eliminateOnLooseLastHealth"
    static let nextTurnOnEliminated = "nextTurnOnEliminated"
    static let discardCardsOnEliminated = "discardCardsOnEliminated"
    static let gameOverOnEliminated = "gameOverOnEliminated"
}

public extension String {
    // https://regex101.com/
    static let regexSaveByBarrel = "♥️"
    static let regexEscapeFromJail = "♥️"
    static let regexPassDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
}
