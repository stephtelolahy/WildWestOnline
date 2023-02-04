//
//  EventContextImpl.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public struct EventContextImpl: EventContext {
    private var _actor: String?
    private var _card: Card?
    public var target: String?
    
    public init(actor: String? = nil, card: Card? = nil, target: String? = nil) {
        self._actor = actor
        self._card = card
        self.target = target
    }
    
    public var actor: String {
        guard let actor = _actor else {
            fatalError(InternalError.missingActor)
        }
        
        return actor
    }
    
    public var card: Card {
        guard let card = _card else {
            fatalError(InternalError.missingPlayedCard)
        }
        
        return card
    }
}
