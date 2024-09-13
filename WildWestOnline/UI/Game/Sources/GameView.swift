//
//  GameView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order no_magic_numbers

import SwiftUI
import Theme
import Redux

struct GameView: View {
    struct State: Equatable {
        let players: [PlayerItem]
        let message: String
        let chooseOne: ChooseOne?
        let handCards: [HandCard]
        let topDiscard: String?
        let topDeck: String?
        let animationDelay: TimeInterval
        let startOrder: [String]
        let deckCount: Int

        struct PlayerItem: Equatable {
            let id: String
            let imageName: String
            let displayName: String
            let health: Int
            let maxHealth: Int
            let handCount: Int
            let inPlay: [String]
            let isTurn: Bool
            let isTargeted: Bool
            let isEliminated: Bool
            let role: String?
            let userPhotoUrl: String?
        }

        struct HandCard: Equatable {
            let card: String
            let active: Bool

            init(card: String, active: Bool) {
                self.card = card
                self.active = active
            }
        }

        struct ChooseOne: Equatable {
            let choiceType: String
            let options: [String]

            init(choiceType: String, options: [String]) {
                self.choiceType = choiceType
                self.options = options
            }
        }
    }

    enum Action {
        case didAppear
        case didTapCloseButton
        case didPlayCard(String)
        case didChooseOption(String)
    }

    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State, Action>

    init(store: @escaping () -> Store<State, Action>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        ZStack {
            theme.backgroundView.edgesIgnoringSafeArea(.all)
            UIViewControllerRepresentableBuilder {
                GamePlayViewController(store: store)
            }
        }
        .foregroundColor(.primary)
        .navigationBarHidden(true)
    }
}

#Preview {
    GameView {
        .init(initial: .mockedData)
    }
}

private extension GameView.State {
    static var mockedData: Self {
        let player1 = GameView.State.PlayerItem(
            id: "p1",
            imageName: "willyTheKid",
            displayName: "willyTheKid",
            health: 2,
            maxHealth: 4,
            handCount: 5,
            inPlay: ["scope", "jail"],
            isTurn: true,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        let player2 = GameView.State.PlayerItem(
            id: "p2",
            imageName: "calamityJanet",
            displayName: "calamityJanet",
            health: 1,
            maxHealth: 4,
            handCount: 0,
            inPlay: ["scope", "jail"],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        return .init(
            players: [player1, player2, player2, player2, player2, player2, player2],
            message: "P1's turn",
            chooseOne: nil,
            handCards: [
                .init(card: "mustang-2♥️", active: false),
                .init(card: "gatling-4♣️", active: true),
                .init(card: "endTurn", active: true)
            ],
            topDiscard: "bang-A♦️",
            topDeck: nil,
            animationDelay: 1000,
            startOrder: [],
            deckCount: 12
        )
    }
}
