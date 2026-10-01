//
//  SettingsCardsView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import SwiftUI
import Redux
import CardResources

struct SettingsCardsView: View {
    typealias ViewStore = Store<SettingsCardsFeature.State, SettingsCardsFeature.Action>

    @StateObject private var store: ViewStore

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.cards, id: \.name) { card in
                rowView(card: card)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(store.state.kind == .abilities ? "Abilities" : "Collectibles")
        .task {
            await store.dispatch(.didAppear)
        }
    }

    func rowView(card: SettingsCardsFeature.State.Card) -> some View {
        HStack(alignment: .top) {
            image(for: card)
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 100)

            VStack(alignment: .leading) {
                Text(card.name.uppercased())
                    .bold()
                Text(card.description)
            }
        }
        .foregroundStyle(.foreground)
    }

    private func image(for card: SettingsCardsFeature.State.Card) -> Image {
        switch store.state.kind {
        case .collectibles: Image(card.name, bundle: .cardResources)
        case .abilities: Image(systemName: "circle.square")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsCardsView {
            .init(
                initialState: .init(
                    kind: .collectibles,
                    cards: [
                        .init(
                            name: .bang,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        ),
                        .init(
                            name: .missed,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        ),
                        .init(
                            name: .dodge,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        )
                    ]
                )
            )
        }
    }
}
