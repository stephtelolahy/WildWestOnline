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
    @State private var waitingActions: [String: GameAction] = [:]

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
                        Button(action: {
                            if !player.waitingActions.isEmpty {
                                showingOptions = true
                                waitingActions = player.waitingActions
                            }
                        }, label: {
                            itemPlayerView(player)
                        })
                        .confirmationDialog(
                            "Select an action",
                            isPresented: $showingOptions,
                            titleVisibility: .visible
                        ) {
                            let options = Array(waitingActions.keys)
                            ForEach(options, id: \.self) { key in
                                Button(key) {
                                    guard let action = waitingActions[key] else {
                                        fatalError("unexpected")
                                    }
                                    store.dispatch(action)
                                }
                            }
                        }
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

    private func itemPlayerView(_ player: PlayerItem) -> some View {
        ZStack {
            HStack {
                CircleImage(
                    image: Image(
                        player.imageName,
                        bundle: Bundle.module,
                        label: Text(player.imageName)
                    ),
                    size: 50
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

            if !player.waitingActions.isEmpty {
                Image(systemName: "\(player.waitingActions.count).circle.fill")
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
                .withInPlay(["scope", "barrel"])
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .withChooseOne("p1", options: ["bang": .nothing])
        .build()
    return GamePlayState(gameState: game, selectedPlayer: "p1")
}
