//
//  CardAction.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

/// Describing card action
public struct CardAction: Codable, Equatable {

    /// Describing when card action is triggered
    let eventReq: EventReq

    /// The side effect
    let effect: CardEffect
    
    /// Play requirements
    let playReqs: [PlayReq]
}
