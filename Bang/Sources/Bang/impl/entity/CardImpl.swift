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
    public var playTarget: ArgPlayer?
    public var canPlay: [PlayReq]
    public var onPlay: [Effect]
    public var triggers: [PlayReq]
    public var onTrigger: [Effect]
    
    public init(id: String = "",
                name: String = "",
                value: String = "",
                playTarget: ArgPlayer? = nil,
                canPlay: [PlayReq] = [],
                onPlay: [Effect] = [],
                triggers: [PlayReq] = [],
                onTrigger: [Effect] = []) {
        self.id = id
        self.name = name
        self.value = value
        self.playTarget = playTarget
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.triggers = triggers
        self.onTrigger = onTrigger
    }
}
