//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import NavigationCore

struct SplashView: View {
    struct State: Equatable, Sendable {
    }

    @StateObject private var store: Store<State, Void>

    init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("splash.editor.name", bundle: .module)
                .font(.callout)
                .foregroundStyle(.red)
        }
        .navigationBarHidden(true)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await store.dispatch(NavigationStackAction<MainDestination>.push(.home))
        }
    }
}

#Preview {
    SplashView {
        .init(initialState: .init(), dependencies: ())
    }
}
