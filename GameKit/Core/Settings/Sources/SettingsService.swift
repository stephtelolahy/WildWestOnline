//
//  SettingsService.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 07/05/2024.
//

public protocol SettingsService {
    var playersCount: Int { get set }
    var waitDelayMilliseconds: Int { get set }
    var simulationEnabled: Bool { get set }
    var gamePlay: Int { get set }
    var preferredFigure: Int { get set }
}
