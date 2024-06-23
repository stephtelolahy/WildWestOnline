//
//  GamePlayView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order no_magic_numbers

import AppCore
import CardsRepository
import GameCore
import Redux
import SwiftUI
import Theme

public struct GamePlayView: View {
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
    GamePlayView {
        Store(initial: .sample)
    }
}

private extension GamePlayView.State {
    static var sample: Self {
        let player1 = GamePlayView.State.PlayerItem(
            id: "p1",
            imageName: .willyTheKid,
            displayName: .willyTheKid,
            health: 2,
            maxHealth: 4,
            handCount: 5,
            inPlay: [.scope, .jail],
            isTurn: true,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        let player2 = GamePlayView.State.PlayerItem(
            id: "p2",
            imageName: .calamityJanet,
            displayName: .calamityJanet,
            health: 1,
            maxHealth: 4,
            handCount: 0,
            inPlay: [.scope, .jail],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        return .init(
            players: [player1, player2, player2, player2, player2, player2, player2],
            message: "P1's turn",
            chooseOneData: nil,
            handActions: [
                .init(card: "\(String.mustang)-2♥️", action: nil),
                .init(card: .gatling, action: .play(.gatling, player: "p1")),
                .init(card: .endTurn, action: .play(.endTurn, player: "p1"))
            ],
            topDiscard: .bang,
            topDeck: nil,
            animationDelay: 1000,
            startOrder: [],
            deckCount: 12,
            occurredEvent: .damage(1, player: .calamityJanet)
        )
    }
}
