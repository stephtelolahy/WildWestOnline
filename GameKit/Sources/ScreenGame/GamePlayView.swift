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
                            store.dispatch(GamePlayAction.onSelectPlayer(playerId))
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
            Text(store.state.message)
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
        Text("Details")
    }

    private func itemPlayerView(_ player: Player) -> some View {
        HStack {
            CircleImage(image: player.image, size: 50)
            Text("\(player.figure.uppercased())\n\(player.inPlay.cards.joined(separator: "-"))")
                .font(.callout)
                .lineLimit(2)
            Spacer()
            Text("[]\(player.hand.count)\t❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)")
                .lineLimit(1)
                .padding(.trailing, 8)
        }
        .background(Color.accentColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

#Preview {
    GamePlayView {
        Store<GamePlayState>(initial: previewState)
    }
}

extension Player {
    var image: Image {
        Image(figure, bundle: Bundle.module)
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
