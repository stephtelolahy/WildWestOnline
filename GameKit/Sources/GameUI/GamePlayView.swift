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
import Theme

public struct GamePlayView: View {
    @StateObject private var store: Store<GameState>

    public init(store: @escaping () -> Store<GameState>) {
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
                    ForEach(store.state.visiblePlayers) {
                        itemPlayerButton($0)
                        Divider()
                    }
                    logView
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .alert(
            "Choose one option",
            isPresented: Binding<Bool>(
                get: { store.state.chooseOneAlertData.isNotEmpty },
                set: { _ in }
            ),
            presenting: store.state.chooseOneAlertData
        ) { data in
            ForEach(Array(data.keys), id: \.self) { key in
                Button(key, role: key == .pass ? .cancel : nil) {
                    guard let action = data[key] else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
            }
        }
        .onAppear {
            let sheriff = store.state.playOrder[0]
            store.dispatch(GameAction.setTurn(sheriff))
        }
    }

    private var headerView: some View {
        ZStack {
            Text(store.state.message)
                .font(.headline)
                .lineLimit(1)
                .padding()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        store.dispatch(NavAction.dismiss)
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(AppColor.button)
                        .padding()
                        .font(.title)
                }
            }
        }
    }

    private func itemPlayerButton(_ player: PlayerItem) -> some View {
        Button(action: {
//            store.dispatch(GamePlayAction.didSelectPlayer(player.id))
        }, label: {
            itemPlayerView(player)
        })
//        .confirmationDialog(
//            "Play a card",
//            isPresented: Binding<Bool>(
//                get: { store.state.activeSheetData.isNotEmpty },
//                set: { _ in }
//            ),
//            titleVisibility: .visible,
//            presenting: store.state.activeSheetData
//        ) { data in
//            ForEach(Array(data.keys), id: \.self) { key in
//                Button(key) {
//                    guard let action = data[key] else {
//                        fatalError("unexpected")
//                    }
//                    store.dispatch(action)
//                }
//            }
//        }
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

            if player.activeActions.isNotEmpty {
                Image(systemName: "\(player.activeActions.count).circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
        }
        .background(Color.white.opacity(player.highlighted ? 0.4 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
    }

    private var logView: some View {
        let logs = store.log
            .reversed()
            .map { String(describing: $0) }
        return ForEach(logs, id: \.self) { message in
            Text(message)
                .lineLimit(1)
                .font(.footnote)
        }
    }
}

#Preview {
    GamePlayView {
        Store<GameState>(initial: previewState)
    }
}

private var previewState: GameState {
    GameState.makeBuilder()
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
        .withChooseOne("p1", options: [.bang: GameAction.nothing])
        .withTurn("p1")
        .build()
}
