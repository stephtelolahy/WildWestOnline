//
//  CardImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct CardImpl: Card {
    public var id: String
    public var name: String
    public var value: String
    public var canPlay: [PlayReq]
    public var onPlay: [Effect]
    
    public init(id: String = "",
                name: String = "",
                value: String = "",
                canPlay: [PlayReq] = [],
                onPlay: [Effect] = []) {
        self.id = id
        self.name = name
        self.value = value
        self.canPlay = canPlay
        self.onPlay = onPlay
    }
}
