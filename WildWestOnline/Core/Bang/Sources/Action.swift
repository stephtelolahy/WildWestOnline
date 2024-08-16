//
//  Action.swift
//
//
//  Created by Hugues Telolahy on 15/08/2024.
//

import Foundation

public struct Action: Equatable, Codable {
    /// event type
    public let type: ActionType
    /// payload of the event
    public let payload: [ActionArgument: String]
}
