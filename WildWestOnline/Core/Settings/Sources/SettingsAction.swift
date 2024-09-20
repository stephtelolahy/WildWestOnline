//
//  SettingsAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//
import Redux

public enum SettingsAction: Action {
    case updatePlayersCount(Int)
    case updateWaitDelaySeconds(Double)
    case toggleSimulation
    case updatePreferredFigure(String?)
}
