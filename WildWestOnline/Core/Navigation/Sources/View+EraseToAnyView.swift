//
//  View+EraseToAnyView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import SwiftUICore

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
