//
//  SettingsCollectiblesView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import SwiftUI
import Redux
import CardResources

struct SettingsCollectiblesView: View {
    typealias ViewStore = Store<SettingsCollectiblesFeature.State, SettingsCollectiblesFeature.Action>

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
        .navigationTitle("Collectibles")
        .task {
            await store.dispatch(.onAppear)
        }
    }

    func rowView(card: SettingsCollectiblesFeature.State.Card) -> some View {
        HStack {
            Image(card.name, bundle: .cardResources)
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
}

#Preview {
    NavigationStack {
        SettingsCollectiblesView {
            .init(
                initialState: .init(
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
