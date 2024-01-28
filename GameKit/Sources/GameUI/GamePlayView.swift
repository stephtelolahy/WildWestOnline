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
            ForEach(store.state.visiblePlayers, id: \.id) {
                itemPlayerView($0)
            }
            Divider()
            logView
            footerView
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .alert(
            "Choose one option",
            isPresented: Binding<Bool>(
                get: { store.state.chooseOneActions.isNotEmpty },
                set: { _ in }
            ),
            presenting: store.state.chooseOneActions
        ) { data in
            ForEach(Array(data.keys.sorted()), id: \.self) { key in
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
            store.dispatch(GameAction.setTurn(player: sheriff))
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
                        store.dispatch(GamePlayAction.quit)
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
            }
        }
    }

    private var footerView: some View {
        let data = store.state.handActions
        return TagFlowLayout(alignment: .leading) {
            ForEach(data, id: \.card) { item in
                Button("\(item.card)") {
                    guard let action = item.action else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
                .buttonStyle(.borderedProminent)
                .disabled(item.action == nil)
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
                Text("\(player.hand)\t\(player.health)")
                    .lineLimit(1)
                    .padding(.trailing, 8)
            }
        }
        .background(itemPlayerBackgroundColor(for: player.state))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
    }

    private var logView: some View {
        let logs = store.log.reversed()
            .map { String(describing: $0) }
        return ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(logs.enumerated()), id: \.offset) { _, event in
                    Text(event)
                }
            }
        }
    }

    private func itemPlayerBackgroundColor(for state: PlayerItem.State) -> Color {
        switch state {
        case .active:
            Color.white.opacity(0.6)

        case .idle:
            Color.white.opacity(0.2)

        case .eliminated:
            Color.clear
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
                .withAttributes([.maxHealth: 3])
                .withAbilities([.endTurn, .willyTheKid])
                .withHand([.bang, .gatling, .schofield, .mustang, .barrel, .beer])
                .withInPlay([.saloon, .barrel])
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
                .withAttributes([.maxHealth: 4])
        }
        .withActive([.bang, .mustang, .barrel, .beer, .endTurn], player: "p1")
        .withChooseOne(.card, options: [.missed, .bang], player: "p2")
        .withTurn("p1")
        .withPlayModes(["p1": .manual])
        .build()
}
