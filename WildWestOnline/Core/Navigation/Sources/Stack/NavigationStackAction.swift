//
//  NavigationAction.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public enum NavigationStackAction<T: Destination>: Action {
    case push(T)
    case pop
    case setPath([T])
    case present(T)
    case dismiss
}
