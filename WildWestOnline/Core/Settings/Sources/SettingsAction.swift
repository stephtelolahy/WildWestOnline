//
//  SettingsAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//
import Redux

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case updatePreferredFigure(String?)
}