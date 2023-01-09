//
//  CardImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//

struct CardImpl: Card {
    var id: String = ""
    let name: String
    var value: String = ""
    var type: CardType
    var canPlay: [PlayReq] = []
    var onPlay: [Effect] = []
}
