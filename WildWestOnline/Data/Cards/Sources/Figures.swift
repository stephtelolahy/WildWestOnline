//
//  Figures.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 06/04/2025.
//
import GameCore

public enum Figures {
    static let all: [Card] = [
        willyTheKid,
        roseDoolan,
        paulRegret,
    ]
    
    public static let allNames: [String] = all.map(\.name)
}

private extension Figures {
    static var willyTheKid: Card {
        .init(
            name: .willyTheKid,
            desc: "he can play any number of BANG! cards during his turn.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 4)
                ),
                .init(
                    name: .setPlayLimitPerTurn,
                    payload: .init(amountPerTurn: [.bang: .infinity])
                )
            ]
        )
    }
    
    static var roseDoolan: Card {
        .init(
            name: .roseDoolan,
            desc: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 4)
                ),
                .init(
                    name: .increaseMagnifying,
                    payload: .init(amount: 1)
                )
            ]
        )
    }
    
    static var paulRegret: Card {
        .init(
            name: .paulRegret,
            desc: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 3)
                ),
                .init(
                    name: .increaseRemoteness,
                    payload: .init(amount: 1)
                )
            ]
        )
    }
}

public extension String {
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
    static let elenaFuente = "elenaFuente"
    static let seanMallory = "seanMallory"
    static let tequilaJoe = "tequilaJoe"
    static let pixiePete = "pixiePete"
    static let billNoface = "billNoface"
    static let gregDigger = "gregDigger"
    static let herbHunter = "herbHunter"
    static let mollyStark = "mollyStark"
    static let joseDelgado = "joseDelgado"
    static let chuckWengam = "chuckWengam"
    static let docHolyday = "docHolyday"
    static let apacheKid = "apacheKid"
    static let belleStar = "belleStar"
    static let patBrennan = "patBrennan"
    static let veraCuster = "veraCuster"
    static let coloradoBill = "coloradoBill"
    static let evelynShebang = "evelynShebang"
    static let lemonadeJim = "lemonadeJim"
    static let henryBlock = "henryBlock"
    static let blackFlower = "blackFlower"
    static let derSpotBurstRinger = "derSpotBurstRinger"
    static let tucoFranziskaner = "tucoFranziskaner"
}
