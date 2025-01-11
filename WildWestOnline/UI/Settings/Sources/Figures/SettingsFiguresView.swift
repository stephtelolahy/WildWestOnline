//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import Redux
import SwiftUI
import SettingsCore

struct SettingsFiguresView: View {
    struct State: Equatable {
        let figures: [Figure]

        struct Figure: Equatable {
            let name: String
            let isFavorite: Bool
        }
    }

    @StateObject private var store: Store<State, Void>

    init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.figures, id: \.name) { figure in
                Button(action: {
                    Task {
                        await store.dispatch(SettingsAction.updatePreferredFigure(figure.name))
                    }
                }, label: {
                    FigureRow(figure: figure)
                })
            }
        }
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
