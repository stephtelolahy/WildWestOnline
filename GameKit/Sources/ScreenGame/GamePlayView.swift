//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Game
import Inventory
import Redux
import Routing
import SwiftUI

public struct GamePlayView: View {
    @StateObject private var store: Store<GamePlayState>

    @State private var showingOptions = false
    @State private var activeActions: [String: GameAction] = [:]

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
                VStack(alignment: .leading) {
                    ForEach(store.state.players) { player in
                        itemPlayerButton(player)
                        Divider()
                    }
                    detailsView
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            let sheriff = store.state.gameState.playOrder[0]
            store.dispatch(GameAction.setTurn(sheriff))
        }
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
            Text(store.state.message)
                .font(.subheadline)
                .lineLimit(1)
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
        Text("Details")
    }

    private func itemPlayerButton(_ player: PlayerItem) -> some View {
        Button(action: {
            if !player.activeActions.isEmpty {
                showingOptions = true
                activeActions = player.activeActions
            }
        }, label: {
            itemPlayerView(player)
        })
        .confirmationDialog(
            "Play a card",
            isPresented: $showingOptions,
            titleVisibility: .visible
        ) {
            let options = Array(activeActions.keys)
            ForEach(options, id: \.self) { key in
                Button(key) {
                    guard let action = activeActions[key] else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
            }
        }
    }

    private func itemPlayerView(_ player: PlayerItem) -> some View {
        ZStack {
            HStack {
                CircleImage(
                    image: Image(
                        player.imageName,
                        bundle: Bundle.module,
                        label: Text(player.imageName)
                    )
                )
                VStack(alignment: .leading) {
                    Text(player.displayName)
                        .font(.callout)
                        .lineLimit(1)
                    Text(player.equipment)
                        .font(.footnote)
                        .lineLimit(1)
                }
                Spacer()
                Text(player.status)
                    .lineLimit(1)
                    .padding(.trailing, 8)
            }

            if !player.activeActions.isEmpty {
                Image(systemName: "\(player.activeActions.count).circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
        }
        .background(Color.accentColor.opacity(player.highlighted ? 0.5 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
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
                .withInPlay([.saloon, .barrel])
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .withActive("p1", cards: [.bang, .endTurn])
        .build()
    return GamePlayState(gameState: game    )
}
