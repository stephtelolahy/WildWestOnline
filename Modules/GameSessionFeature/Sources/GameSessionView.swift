//
//  GameSessionView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable identifier_name force_unwrapping

import SwiftUI
import Redux
import Theme
import GameFeature

public struct GameSessionView: View {
    public typealias ViewStore = Store<GameSessionFeature.State, GameSessionFeature.Action>

    @StateObject private var store: ViewStore

    @State private var animationSource: CGPoint = .zero
    @State private var animationTarget: CGPoint = .zero
    @State private var animatedCard: CardContent?
    @State private var isAnimating = false

    @Environment(\.theme) private var theme

    private let animationMatcher = AnimationMatcher()

    public init(store: @escaping () -> ViewStore) {
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        GeometryReader { proxy in
            let objectPositions = gameObjectPositions(proxy: proxy)
            ZStack {
                theme.colorBackground.ignoresSafeArea()

                boardView(positions: objectPositions)

                controlledHandView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .allowsHitTesting(true)

                chooseOneAnchorView()

                if let animatedCard {
                    CardView(content: animatedCard)
                        .position(isAnimating ? animationTarget : animationSource)
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle(store.state.message)
#if os(iOS) || os(tvOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
#endif
            .toolbar { toolBarView }
            .task {
                await store.dispatch(.onAppear)
            }
            .onReceive(store.$state) { state in
                if let action = state.lastEvent {
                    animate(action, positions: objectPositions)
                }
            }
        }
    }
}

private extension GameSessionView {
    var toolBarView: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Menu {
                Button {
                    Task {
                        await store.dispatch(.delegate(.settings))
                    }
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }

                Divider()

                Button(role: .destructive) {
                    Task { await store.dispatch(.delegate(.quit)) }
                } label: {
                    Label {
                        Text(.gameQuitButton)
                    } icon: {
                        Image(systemName: "xmark")
                    }
                }
            } label: { Image(systemName: "ellipsis")
            }
        }
    }

    @ViewBuilder func boardView(positions: [GameArea: CGPoint]) -> some View {
        let players = store.state.players
        let topDiscard: CardContent? = store.state.topDiscard.map { .id($0) }

        CardView(content: .hidden)
            .position(positions[.deck]!)

        if let topDiscard {
            ZStack {
                DiscardGlowRipple()
                    .frame(width: 160, height: 220)
                    .position(positions[.discard]!)
                    .allowsHitTesting(false)
                CardView(content: topDiscard)
                    .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 8)
                    .rotationEffect(.degrees(-2))
                    .position(positions[.discard]!)
            }
        }

        ForEach(players.indices, id: \.self) { index in
            PlayerView(player: players[index])
                .position(positions[.playerHand(players[index].id)]!)
        }

        // Turn badge overlay (non-intrusive)
        if let current = store.state.players.first(where: { $0.isTurn })?.id,
           let pos = positions[.playerHand(current)] {
            TurnBadge()
                .position(CGPoint(x: pos.x, y: pos.y - 68))
                .allowsHitTesting(false)
        }
    }

    @ViewBuilder func controlledHandView() -> some View {
        if let player = store.state.controlledPlayer {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(store.state.handCards, id: \.card) { item in
                            Button(
                                action: {
                                    guard item.active else {
                                        return
                                    }

                                    Task {
                                        await store.dispatch(.game(.preparePlay(item.card, player: player)))
                                    }
                                },
                                label: {
                                    CardView(
                                        content: .id(item.card),
                                        format: .large,
                                        disabled: !item.active
                                    )
                                    .scaleEffect(item.active ? 1.04 : 1.0)
                                    .shadow(color: (item.active ? Color.accentColor : .black).opacity(item.active ? 0.45 : 0.25), radius: item.active ? 14 : 8, x: 0, y: item.active ? 10 : 6)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.85), value: item.active)
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }

    func chooseOneAnchorView() -> some View {
        Color.clear
            .frame(width: 1, height: 1)
            .alert(
                "Resolving \(store.state.chooseOne?.resolvingAction.rawValue ?? "") ...",
                isPresented: Binding<Bool>(
                    get: { store.state.chooseOne != nil },
                    set: { _ in }
                ),
                presenting: store.state.chooseOne,
                actions: { chooseOne in
                    ForEach(chooseOne.options, id: \.self) { option in
                        let button = Button(option) {
                            Task { await self.store.dispatch(.game(.choose(option, player: chooseOne.chooser))) }
                        }

                        if option == .choicePass {
                            button.keyboardShortcut(.defaultAction)
                        } else {
                            button
                        }
                    }
                },
                message: { _ in
                    Text("Select one of the options below")
                }
            )
    }

    func animate(_ action: GameFeature.Action, positions: [GameArea: CGPoint]) {
        if let animation = animationMatcher.animation(on: action) {
            switch animation {
            case let .moveCard(card, source, target):
                moveCard(card, from: source, to: target, positions: positions)
            }
        }
    }

    func moveCard(_ card: CardContent, from source: GameArea, to target: GameArea, positions: [GameArea: CGPoint]) {
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

    func gameObjectPositions(proxy: GeometryProxy) -> [GameArea: CGPoint] {
        let board = CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height * 0.7)
        let center = CGPoint(x: board.size.width / 2, y: board.size.height / 2)
        let horizontalRadius = board.size.width * 0.4
        let verticalRadius = board.size.height * 0.35
        let players = store.state.players

        let handToInPlayDx: CGFloat = 36
        var positions: [GameArea: CGPoint] = [:]
        positions[.deck] = center.applying(CGAffineTransform(translationX: -36, y: 0))
        positions[.discard] = center.applying(CGAffineTransform(translationX: 36, y: 0))
        positions[.discovered] = center.applying(CGAffineTransform(translationX: 0, y: -100))

        for (index, player) in players.enumerated() {
            let angle = (2 * .pi / CGFloat(players.count)) * CGFloat(index) + (.pi / 2)
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

// MARK: - Effects: Discard Glow & Ripple
private struct DiscardGlowRipple: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.orange.opacity(0.18))
                .blur(radius: 30)
                .scaleEffect(animate ? 1.05 : 0.98)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
            // Ripple rings
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(Color.orange.opacity(0.25 - Double(i) * 0.07), lineWidth: 2)
                    .scaleEffect(animate ? 1.2 + CGFloat(i) * 0.15 : 0.9 + CGFloat(i) * 0.15)
                    .blur(radius: 1)
                    .animation(.easeOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(i) * 0.15), value: animate)
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Turn Badge
private struct TurnBadge: View {
    @Environment(\.theme) private var theme

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "crown.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .orange)
            Text("TURN")
                .font(theme.fontHeadline)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        GameSessionView {
            .init(initialState: .previewState)
        }
    }
}

private extension GameSessionFeature.State {
    static var previewState: Self {
        let player1 = GameSessionFeature.State.Player(
            id: "p1",
            imageName: "willyTheKid",
            displayName: "willyTheKid",
            health: 2,
            handCount: 5,
            inPlay: ["scope", "jail"],
            isTurn: true,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        let player2 = GameSessionFeature.State.Player(
            id: "p2",
            imageName: "calamityJanet",
            displayName: "calamityJanet",
            health: 1,
            handCount: 0,
            inPlay: ["scope", "jail"],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        let player3 = GameSessionFeature.State.Player(
            id: "p3",
            imageName: "elGringo",
            displayName: "elGringo",
            health: 0,
            handCount: 0,
            inPlay: [],
            isTurn: false,
            isTargeted: false,
            isEliminated: true,
            role: nil,
            userPhotoUrl: nil
        )

        return .init(
            game: nil,
            players: [player1, player2, player3],
            message: "P1's turn",
            chooseOne: .init(
                resolvingAction: .counterShot,
                chooser: "p1",
                options: ["o1", "o2", .choicePass]
            ),
            handCards: [
                .init(card: "mustang-2♥️", active: false),
                .init(card: "gatling-4♣️", active: true),
                .init(card: "endTurn", active: true)
            ],
            topDiscard: "bang-A♦️",
            topDeck: nil,
            startOrder: [],
            deckCount: 12,
            startPlayer: "p1",
            actionDelaySeconds: 0.5,
            lastEvent: nil,
            controlledPlayer: "p1",
        )
    }
}
