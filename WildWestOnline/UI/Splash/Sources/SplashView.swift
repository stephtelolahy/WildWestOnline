//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import AppCore
import NavigationCore

public struct SplashView: View {
    public struct State: Equatable {}

    @StateObject private var store: Store<State, Void>

    public init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("splash.editor.name", bundle: .module)
                .font(.callout)
                .foregroundStyle(.red)
        }
        .toolbar(.hidden, for: .automatic)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await store.dispatch(NavStackFeature<NavigationFeature.State.MainDestination>.Action.push(.home))
        }
    }
}

#Preview {
    SplashView {
        .init(initialState: .init(), dependencies: ())
    }
}

public extension SplashView.State {
    init?(appState: AppFeature.State) { }
}
