//
//  SettingsAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//
public enum SettingsAction {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case updatePreferredFigure(String?)
}
