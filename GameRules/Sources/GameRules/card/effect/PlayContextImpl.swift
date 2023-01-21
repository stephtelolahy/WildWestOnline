//
//  PlayContextImpl.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public struct PlayContextImpl: PlayContext {
    private var _actor: String?
    private var _playedCard: Card?
    public var target: String?
    
    public init(actor: String? = nil, playedCard: Card? = nil, target: String? = nil) {
        self._actor = actor
        self._playedCard = playedCard
        self.target = target
    }
    
    public var actor: String {
        guard let actor = _actor else {
            fatalError(InternalError.missingActor)
        }
        
        return actor
    }
    
    public var playedCard: Card {
        guard let card = _playedCard else {
            fatalError(InternalError.missingPlayerCard(""))
        }
        
        return card
    }
}
