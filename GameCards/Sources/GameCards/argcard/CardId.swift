//
//  CardId.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// card identified by X
public struct CardId: ArgCard, Equatable {
    let id: String
    
    public init(_ id: String) {
        self.id = id
    }
    
    public func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        fatalError(InternalError.unexpected)
    }
}
