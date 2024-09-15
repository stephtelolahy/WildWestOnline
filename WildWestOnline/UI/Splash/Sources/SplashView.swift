//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

import SwiftUI
import Redux
import AppCore
import NavigationCore

public struct SplashView: View {
    public struct State: Equatable {
    }

    @StateObject private var store: Store<State>

    public init(store: @escaping () -> Store<State>) {
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
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                store.dispatch(NavigationStackAction<RootDestination>.push(.home))
            }
        }
    }
}

#Preview {
    SplashView {
        .init(initial: .init())
    }
}
