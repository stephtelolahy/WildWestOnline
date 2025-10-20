//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import SwiftUI

struct SettingsFiguresView: View {
    @StateObject private var store: ViewStore

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.figures, id: \.name) { figure in
                Button(action: {
                    Task {
                        await store.dispatch(.settings(.updatePreferredFigure(figure.name)))
                    }
                }, label: {
                    FigureRow(figure: figure)
                        .foregroundStyle(.foreground)
                })
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Figures")
    }
}

#Preview {
    SettingsFiguresView {
        .init(
            initialState: .init(figures: [
                .init(name: "Figure1", isFavorite: false),
                .init(name: "Figure2", isFavorite: false),
                .init(name: "Figure3", isFavorite: true)
            ]),
            dependencies: ()
        )
    }
}
