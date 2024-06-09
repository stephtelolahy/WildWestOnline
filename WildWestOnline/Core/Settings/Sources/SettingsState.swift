//
//  SettingsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux

public struct SettingsState: Codable, Equatable {
    public let inventory: Inventory
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool
    public var preferredFigure: String?
}

public enum SettingsAction: ActionV1, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case updatePreferredFigure(String?)
}
