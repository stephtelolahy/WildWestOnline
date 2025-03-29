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
import NavigationCore

enum ViewPosition: Hashable {
    case deck
    case discard
    case discovered
    case playerHand(String)
    case playerInPlay(String)
}

enum CardContent: Equatable {
    case id(String)
    case hidden
}

public struct GameView: View {
    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State, Void>

    @SwiftUI.State private var animationSource: CGPoint = .zero
    @SwiftUI.State private var animationTarget: CGPoint = .zero
    @SwiftUI.State private var animatedCard: CardContent?
    @SwiftUI.State private var isAnimating = false

    private let animationMatcher = AnimationMatcher()

    public init(store: @escaping () -> Store<State, Void>) {
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        GeometryReader { proxy in
            let positions = computePositions(proxy: proxy)
            ZStack {
                theme.backgroundColor.edgesIgnoringSafeArea(.all)

                boardView(positions: positions)

                VStack {
                    Spacer()
                    controlledHandView()
                }

                chooseOneAnchorView()

                if let animatedCard {
                    CardView(content: animatedCard)
                        .position(isAnimating ? animationTarget : animationSource)
                }
            }
            .navigationTitle(store.state.message)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar { toolBarView }
            .task {
                await store.dispatch(GameFeature.Action.startTurn(player: store.state.startPlayer))
            }
            .onReceive(store.eventPublisher) { newEvent in
                if let action = newEvent as? GameFeature.Action,
                   action.isRenderable {
                    animate(action, positions: positions)
                }
            }
        }
    }
}

private extension GameView {
    var toolBarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Actions", action: { })
                Button("Settings") {
                    Task {
                        await store.dispatch(NavStackFeature<NavigationFeature.State.MainDestination>.Action.present(.settings))
                    }
                }
                Divider()
                Button(role: .destructive) {
                    Task { await store.dispatch(GameSessionFeature.Action.quit) }
                } label: { Text("Quit") }
            } label: { Image(systemName: "ellipsis.circle") }
        }
    }

    @ViewBuilder func boardView(positions: [ViewPosition: CGPoint]) -> some View {
        let players = store.state.players
        let topDiscard: CardContent? = store.state.topDiscard.map { .id($0) }

        CardView(content: .hidden)
            .position(positions[.deck]!)

        if let topDiscard {
            CardView(content: topDiscard)
                .position(positions[.discard]!)
        }

        ForEach(players.indices, id: \ .self) { i in
            PlayerView(player: players[i])
                .position(positions[.playerHand(players[i].id)]!)
        }
    }

    @ViewBuilder func controlledHandView() -> some View {
        if let player = store.state.controlledPlayer {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(store.state.handCards, id: \ .card) { item in
                        Button(action: {
                            guard item.active else { return }
                            Task {
                                await store.dispatch(GameFeature.Action.preparePlay(item.card, player: player))
                            }
                        }) {
                            CardView(content: .id(item.card), format: .large, active: item.active)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }

    func chooseOneAnchorView() -> some View {
        Color.clear
            .frame(width: 1, height: 1)
            .actionSheet(item: Binding<GameView.State.ChooseOne?>(
                get: { store.state.chooseOne },
                set: { _ in }
            )) { chooseOne in
                guard let player = store.state.controlledPlayer else {
                    fatalError("Missing chooser")
                }

                return ActionSheet(
                    title: Text("Choose an Option"),
                    message: Text("Select one of the actions below"),
                    buttons: chooseOne.options.map { option in
                            .default(Text(option)) {
                                Task {
                                    await self.store.dispatch(GameFeature.Action.choose(option, player: player))
                                }
                            }
                    }
                )
            }

    }

    func animate(_ action: GameFeature.Action, positions: [ViewPosition: CGPoint]) {
        guard let animation = animationMatcher.animation(on: action) else { return }
        switch animation {
        case let .moveCard(card, source, target):
            moveCard(card, from: source, to: target, positions: positions)
        }
    }

    func moveCard(_ card: CardContent, from source: ViewPosition, to target: ViewPosition, positions: [ViewPosition: CGPoint]) {
        animatedCard = card
        animationSource = positions[source]!
        animationTarget = positions[target]!

        withAnimation(.spring(duration: store.state.actionDelaySeconds)) {
            isAnimating.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + store.state.actionDelaySeconds) {
            isAnimating = false
            animatedCard = nil
        }
    }

    func computePositions(proxy: GeometryProxy) -> [ViewPosition: CGPoint] {
        let board = CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height * 0.7)
        let center = CGPoint(x: board.size.width / 2, y: board.size.height / 2)
        let horizontalRadius = board.size.width * 0.4
        let verticalRadius = board.size.height * 0.35
        let players = store.state.players

        let handToInPlayDx: CGFloat = 36
        var positions: [ViewPosition: CGPoint] = [:]
        positions[.deck] = center.applying(CGAffineTransform(translationX: -36, y:0))
        positions[.discard] = center.applying(CGAffineTransform(translationX: 36, y:0))
        positions[.discovered] = center.applying(CGAffineTransform(translationX: 0, y:-100))

        for (i, player) in players.enumerated() {
            let angle = (2 * .pi / CGFloat(players.count)) * CGFloat(i) + (.pi / 2)
            positions[.playerHand(player.id)] = CGPoint(
                x: center.x + horizontalRadius * cos(angle),
                y: center.y + verticalRadius * sin(angle)
            )
            positions[.playerInPlay(player.id)] = CGPoint(
                x: center.x + horizontalRadius * cos(angle) + handToInPlayDx,
                y: center.y + verticalRadius * sin(angle)
            )
        }
        return positions
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
            startPlayer: "p1",
            actionDelaySeconds: 0.5
        )
    }
}
