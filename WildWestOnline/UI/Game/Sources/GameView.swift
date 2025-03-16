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

    @SwiftUI.State private var viewPositions: [ViewPosition: CGPoint] = [:]
    @SwiftUI.State private var animationSourcePosition: CGPoint = .zero
    @SwiftUI.State private var animationTargetPosition: CGPoint = .zero
    @SwiftUI.State private var animationCard: String?
    @SwiftUI.State private var isAnimating = false
    private let boardSpace = "boardSpace"

    public init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            theme.backgroundColor.edgesIgnoringSafeArea(.all)
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    playersCircleView
                        .frame(height: proxy.size.height * 0.7)

                    Spacer()

                    if let player = store.state.controlledPlayer {
                        handView(for: player)
                    }
                }
            }

            if let animationCard {
                DeckDiscardCardView(content: .card(animationCard))
                    .position(isAnimating ? animationTargetPosition : animationSourcePosition)
            }
        }
        .coordinateSpace(name: boardSpace)
        .onPreferenceChange(ViewPositionKey.self) { newValue in
            MainActor.assumeIsolated {
                self.viewPositions = newValue
            }
        }
        .navigationTitle(store.state.message)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            toolBarView
        }
        .task {
            await store.dispatch(GameAction.startTurn(player: store.state.startPlayer))
        }
        .onReceive(store.eventPublisher) { newEvent in
            if let action = newEvent as? GameAction,
                action.isRenderable {
                animate(action)
            }
        }
    }
}

private extension GameView {
    var playersCircleView: some View {
        GeometryReader { proxy in
            let availableWidth = proxy.size.width
            let availableHeight = proxy.size.height
            let horizontalRadius = availableWidth * 0.4
            let verticalRadius = availableHeight * 0.35
            let center = CGPoint(x: availableWidth / 2, y: availableHeight / 2)
            let players = store.state.players
            let count = players.count
            let discardContent: DeckDiscardCardView.Content = if let topDiscard = store.state.topDiscard {
                .card(topDiscard)
            } else {
                .empty
            }

            ZStack {
                // Place deck and discard view at the center.
                HStack {
                    DeckDiscardCardView(content: .back)
                        .captureViewPosition(for: .deck, in: boardSpace)
                    DeckDiscardCardView(content: discardContent)
                        .captureViewPosition(for: .discard, in: boardSpace)
                }
                .position(x: center.x, y: center.y)

                // Arrange players along an ellipse.
                ForEach(players.indices, id: \.self) { i in
                    // Use the same angle offset so that the current player (index 0) is at the bottom (π/2 radians)
                    let angle = (2 * .pi / CGFloat(count)) * CGFloat(i) + (.pi / 2)

                    PlayerView(player: players[i])
                        .position(
                            x: center.x + horizontalRadius * cos(angle),
                            y: center.y + verticalRadius * sin(angle)
                        )
                        .captureViewPosition(for: .player(players[i].id), in: boardSpace)
                }
            }
        }
    }

    func handView(for player: String) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(store.state.handCards, id: \.card) { item in
                    Button(action: {
                        guard item.active else {
                            return
                        }

                        Task {
                            await store.dispatch(GameAction.play(item.card, player: player))
                        }
                    }) {
                        HandCardView(card: item)
                            .captureViewPosition(for: .hand(item.card), in: boardSpace)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .actionSheet(item: Binding<GameView.State.ChooseOne?>(
                        get: { store.state.chooseOne },
                        set: { _ in }
                    )) { chooseOne in
                        ActionSheet(
                            title: Text("Choose an Option"),
                            message: Text("Select one of the actions below"),
                            buttons: chooseOne.options.map { option in
                                    .default(Text(option)) {
                                        Task {
                                            await self.store.dispatch(GameAction.choose(option, player: player))
                                        }
                                    }
                            }
                        )
                    }
                }
            }
            .padding()
        }
    }

    var toolBarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Actions", action: { print("Actions tapped") })
                Button("Settings", action: { print("Settings tapped") })
                Divider()
                Button(role: .destructive) {
                    Task {
                        await store.dispatch(SetupGameAction.quitGame)
                    }
                } label: {
                    Text("Quit")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }

    func animate(_ action: GameAction) {
        switch action.kind {
        case .discardPlayed:
            let playerIsControlled = action.payload.target == store.state.controlledPlayer
            if playerIsControlled {
                animateCard(
                    action.payload.card!,
                    from: .hand(action.payload.card!),
                    to: .discard
                )
            } else {
                animateCard(
                    action.payload.card!,
                    from: .player(action.payload.target),
                    to: .discard
                )
            }

        default:
            print("No animation for \(action)")
        }
    }

    func animateCard(
        _ card: String,
        from sourcePosition: ViewPosition,
        to targetPosition: ViewPosition
    ) {
        animationCard = card
        animationSourcePosition = viewPositions[sourcePosition]!
        animationTargetPosition = viewPositions[targetPosition]!
        withAnimation(.spring(duration: 0.5)) {
            isAnimating.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = false
            animationCard = nil
        }
    }
}

private enum ViewPosition: Hashable {
    case deck
    case discard
    case hand(String)
    case player(String)
}

private struct ViewPositionKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [ViewPosition: CGPoint] = [:]

    static func reduce(value: inout [ViewPosition: CGPoint], nextValue: () -> [ViewPosition: CGPoint]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

private extension View {
    func captureViewPosition(for key: ViewPosition, in space: String) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ViewPositionKey.self,
                        value: [
                            key: CGPoint(
                                x: proxy.frame(in: .named(space)).midX,
                                y: proxy.frame(in: .named(space)).midY
                            )
                        ]
                    )
            }
        )
    }
}

#Preview {
    NavigationStack {
        GameView {
            .init(initialState: .mock, dependencies: ())
        }
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
