//
//  GamePlayUIKitView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order

import AppCore
import Redux
import SwiftUI
import Theme

public struct GamePlayUIKitView: View {
    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State>

    public init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundView.edgesIgnoringSafeArea(.all)
                UIViewControllerRepresentableBuilder {
                    GamePlayViewController(store: store)
                }
            }
        }
    }
}

#Preview {
    GamePlayUIKitView {
        Store(initial: previewState)
    }
}

private var previewState: GamePlayUIKitView.State {
    .init(
        players: [],
        message: "",
        chooseOneActions: [:],
        handActions: [],
        events: []
    )
}
