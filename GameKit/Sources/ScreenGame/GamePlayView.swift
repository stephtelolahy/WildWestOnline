//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Game
import Redux
import Routing
import SwiftUI

public struct GamePlayView: View {
    @StateObject private var store: Store<GamePlayState>

    public init(store: @escaping () -> Store<GamePlayState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    let columnLayout = Array(repeating: GridItem(), count: 3)

    @State private var selectedPlayer: String?

    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                headerView
                    .padding()
                ScrollView {
                    boardView
                    detailsView
                }
                messageView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var headerView: some View {
        Button {
            withAnimation {
                store.dispatch(NavAction.dismiss)
            }
        } label: {
            HStack {
                Image(systemName: "hand.point.left.fill")
                Text("game.quit.button", bundle: .module)
            }
            .foregroundColor(.accentColor)
        }
        .padding()
    }

    private var boardView: some View {
        LazyVGrid(columns: columnLayout) {
            ForEach(store.state.boardItem) { item in
                Button {
                    switch item {
                    case let .player(playerId):
                        selectedPlayer = playerId

                    default:
                        selectedPlayer = nil
                    }
                    print("select \(selectedPlayer ?? "none")")
                } label: {
                    Group {
                        switch item {
                        case let .player(playerId):
                            let player = store.state.gameState.player(playerId)
                            gridItemPlayerView(player)

                        case let .discard(card):
                            Text(card ?? "discard")

                        case .empty:
                            Text("empty")
                        }
                    }
                    .background(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 4.0))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
    }

    private var detailsView: some View {
        ForEach(store.state.players) {
            PlayerView(player: $0)
        }
    }

    private var floatingButton: some View {
        Button {
            let sheriff = store.state.gameState.playOrder[0]
            store.dispatch(GameAction.setTurn(sheriff))
        } label: {
            Image(systemName: "gamecontroller")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Circle())
        }
        .padding(.bottom, 60)
    }

    private var messageView: some View {
        Text(String(format: String(localized: "game.message", bundle: .module), store.state.message ?? ""))
            .font(.subheadline)
            .padding()
    }

    private func gridItemPlayerView(_ player: Player) -> some View {
        VStack {
            CircleImage(image: player.image)
            Text(player.figure)
                .lineLimit(1)
            Text("❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)")
            Text("[]\(player.hand.count)")
        }
        .padding()
    }
}

#Preview {
    GamePlayView {
        Store<GamePlayState>(initial: previewState)
    }
}

private var previewState: GamePlayState {
    let game = GameState.makeBuilder()
        .withPlayer("p1") {
            $0.withFigure(.willyTheKid)
                .withHealth(1)
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .build()
    return GamePlayState(gameState: game)
}
