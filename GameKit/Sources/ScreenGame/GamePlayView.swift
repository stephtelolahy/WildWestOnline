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
    @State private var selectedPlayer: String?

    public init(store: @escaping () -> Store<GamePlayState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            ScrollView {
                VStack {
                    ForEach(store.state.gameState.startOrder, id: \.self) { playerId in
                        Button(action: {
                            selectedPlayer = playerId
                        }, label: {
                            itemPlayerView(store.state.gameState.player(playerId))
                        })
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var headerView: some View {
        HStack {
            Button {
                withAnimation {
                    store.dispatch(NavAction.dismiss)
                }
            } label: {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.accentColor)
                    .padding()
            }
            Spacer()
            Text(store.state.message ?? "")
                .font(.subheadline)
                .padding()
            Spacer()
            Button {
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.accentColor)
                    .padding()
            }
        }
    }

    private var detailsView: some View {
        ForEach(store.state.players) {
            PlayerView(player: $0)
        }
    }

    private func itemPlayerView(_ player: Player) -> some View {
        HStack {
            CircleImage(image: player.image)
            Text("\(player.figure)\t[]\(player.hand.count)\n\(player.inPlay.cards.joined(separator: "-"))")
            Spacer()
            Text("❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)")
        }
        .background(Color.accentColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
        .padding(.leading, 10)
        .padding(.trailing, 10)
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
