//
//  SettingsAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//
public enum SettingsAction: Sendable {
    case updatePlayersCount(Int)
    case updateActionDelayMilliSeconds(Int)
    case toggleSimulation
    case updatePreferredFigure(String?)
}
