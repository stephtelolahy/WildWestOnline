//
//  CardId.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
/// card identified by X
public struct CardId: ArgCard, Equatable {
    let id: String
    
    public init(_ id: String) {
        self.id = id
    }
    
    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        .success(.identified([id]))
    }
}
