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

    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
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
                List {
                    Section {
                        ForEach(store.state.players) {
                            PlayerView(player: $0)
                        }
                    }
                }
                Text(String(format: String(localized: "game.message", bundle: .module), store.state.message ?? ""))
                    .font(.subheadline)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            floatingButton
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
