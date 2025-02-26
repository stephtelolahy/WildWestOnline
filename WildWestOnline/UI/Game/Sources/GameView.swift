//
//  GameView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//

import SwiftUI
import Theme
import Redux
import AppCore
import GameCore

public struct GameView: View {
    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State, Void>

    public init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            theme.backgroundColor.edgesIgnoringSafeArea(.all)
            //            UIViewControllerRepresentableBuilder { GamePlayViewController(store: store) }
            gamePlayView
        }
        .foregroundColor(.primary)
        .navigationBarHidden(true)
    }

    private var gamePlayView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text(store.state.message)
                    Button {
                        Task {
                            await store.dispatch(SetupGameAction.quitGame)
                        }
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }

                // Top: Circular arrangement of players.
                GeometryReader { geometry in
                    let availableWidth = geometry.size.width
                    let availableHeight = geometry.size.height
                    // Compute horizontal and vertical radii for an oval layout.
                    let horizontalRadius = availableWidth * 0.4
                    let verticalRadius = availableHeight * 0.35
                    let center = CGPoint(x: availableWidth / 2, y: availableHeight / 2)
                    let players = store.state.players
                    let count = players.count

                    ZStack {
                        // Place deck and discard view at the center.
                        DeckDiscardView(
                            topDiscard: store.state.topDiscard
                        )
                            .position(x: center.x, y: center.y)

                        // Arrange players along an ellipse.
                        ForEach(players.indices, id: \.self) { i in
                            // Use the same angle offset so that the current player (index 0) is at the bottom (π/2 radians)
                            let angle = (2 * .pi / CGFloat(count)) * CGFloat(i) + (.pi / 2)

                            PlayerView(player: players[i])
                                .position(x: center.x + horizontalRadius * cos(angle),
                                          y: center.y + verticalRadius * sin(angle))
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.7)
                .padding(.top)

                Spacer()

                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(store.state.handCards, id: \.card) { item in
                            Button(action: {
                                guard item.active,
                                      let player = store.state.controlledPlayer else {
                                    return
                                }

                                Task {
                                    await store.dispatch(GameAction.play(item.card, player: player))
                                }
                            }) {
                                HandCardView(card: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await store.dispatch(GameAction.startTurn(player: store.state.startPlayer))
        }
    }
}

#Preview {
    GameView {
        .init(initialState: .mock, dependencies: ())
    }
}

private extension GameView.State {
    static var mock: Self {
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
            animationDelay: 1,
            startOrder: [],
            deckCount: 12,
            controlledPlayer: "p1",
            startPlayer: "p1"
        )
    }
}
