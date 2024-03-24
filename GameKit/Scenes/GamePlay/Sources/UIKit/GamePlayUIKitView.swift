//
//  GamePlayUIKitView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order no_magic_numbers

import AppCore
import CardNames
import GameCore
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
        players: [
            .init(
                name: .willyTheKid,
                health: 2,
                maxHealth: 4,
                handCount: 5,
                inPlay: [.scope, .jail],
                isTurn: true,
                isHitLooseHealth: false,
                isHitSomeAction: false,
                isEliminated: false,
                role: nil,
                userPhotoUrl: nil
            ),
            .init(
                name: .bartCassidy,
                health: 1,
                maxHealth: 4,
                handCount: 0,
                inPlay: [.scope, .jail],
                isTurn: false,
                isHitLooseHealth: false,
                isHitSomeAction: false,
                isEliminated: false,
                role: nil,
                userPhotoUrl: nil
            )
        ],
        message: "P1's turn",
        chooseOneActions: [
            .missed: .play(.missed, player: "p2"),
            .bang: .play(.bang, player: "p2")
        ],
        handActions: [
            .init(card: .bang, action: .play(.bang, player: "p1")),
            .init(card: .gatling, action: .play(.gatling, player: "p1")),
            .init(card: .schofield, action: .play(.schofield, player: "p1")),
            .init(card: .mustang, action: nil),
            .init(card: .scope, action: nil),
            .init(card: .barrel, action: .play(.barrel, player: "p1")),
            .init(card: .beer, action: nil)
        ],
        events: [
            "Event2",
            "Event1"
        ]
    )
}
