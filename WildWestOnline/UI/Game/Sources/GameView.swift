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
    @SwiftUI.State private var animationSource: CGPoint = .zero
    @SwiftUI.State private var animationTarget: CGPoint = .zero
    @SwiftUI.State private var animatedCard: CardContent?
    @SwiftUI.State private var isAnimating = false

    private let boardSpace = "boardSpace"
    private let animationMatcher = BoardAnimationMatcher()

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
                    controlledHandView()
                }
            }

            if let animatedCard {
                DeckDiscardCardView(content: animatedCard)
                    .position(isAnimating ? animationTarget : animationSource)
            }

            positionsDebugView()
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
            let discardContent: CardContent = if let topDiscard = store.state.topDiscard {
                .id(topDiscard)
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
                        .captureViewPosition(for: .playerHand(players[i].id), in: boardSpace)
                }
            }
        }
    }

    @ViewBuilder func controlledHandView() -> some View {
        if let player = store.state.controlledPlayer {
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
        } else {
            EmptyView()
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

    @ViewBuilder func positionsDebugView() -> some View {
        if let position = viewPositions[.deck] {
            Text("Deck")
                .font(.footnote)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.blue.opacity(0.8)))
                .position(x: position.x, y: position.x)
        }

        if let position = viewPositions[.discard] {
            Text("Discard")
                .font(.footnote)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.blue.opacity(0.8)))
                .position(x: position.x, y: position.x)
        }

        ForEach(store.state.players, id: \.id) { player in
            if let position = viewPositions[.playerHand(player.id)] {
                Text(player.displayName)
                    .font(.footnote)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color.blue.opacity(0.8)))
                    .position(x: position.x, y: position.x)
            }
        }
    }

    func animate(_ action: GameAction) {
        guard let animation = animationMatcher.animation(on: action) else {
            return
        }

        switch animation {
        case let .moveCard(card, source, target):
            moveCard(card, from: source, to: target)
        }
    }

    func moveCard(
        _ card: CardContent,
        from sourcePosition: ViewPosition,
        to targetPosition: ViewPosition
    ) {
        animatedCard = card
        animationSource = viewPositions[sourcePosition]!
        animationTarget = viewPositions[targetPosition]!
        withAnimation(.spring(duration: 0.5)) {
            isAnimating.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = false
            animatedCard = nil
        }
    }
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

        let player3 = GameView.State.PlayerItem(
            id: "p3",
            imageName: "elGringo",
            displayName: "elGringo",
            health: 1,
            maxHealth: 3,
            handCount: 0,
            inPlay: ["scope"],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        return .init(
            players: [player1, player2, player3],
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
