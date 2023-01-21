//
//  CardImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct CardImpl: Card {
    public var id: String
    public var name: String
    public var value: String?
    public var playMode: PlayMode?
    public var playTarget: ArgPlayer?
    public var canPlay: [PlayReq]?
    public var onPlay: [Effect]?
    public var triggers: [PlayReq]?
    public var onTrigger: [Effect]?
    
    public init(id: String = "",
                name: String = "",
                value: String? = nil,
                playMode: PlayMode? = nil,
                playTarget: ArgPlayer? = nil,
                canPlay: [PlayReq]? = nil,
                onPlay: [Effect]? = nil,
                triggers: [PlayReq]? = nil,
                onTrigger: [Effect]? = nil) {
        self.id = id
        self.name = name
        self.value = value
        self.playMode = playMode
        self.playTarget = playTarget
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.triggers = triggers
        self.onTrigger = onTrigger
    }
}
