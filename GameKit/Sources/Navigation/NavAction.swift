//
//  NavAction.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 30/11/2023.
//

import Redux

public enum NavAction: Action, Codable, Equatable {
    case showScreen(Screen, transition: Transition = .push)
    case dismiss

    public enum Transition: Codable, Equatable {
        case push
        case replace
    }
}
