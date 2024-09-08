//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

import Redux
import SwiftUI

public struct SplashView: View {
    @StateObject private var store: Store<State, Action>

    public init(store: @escaping () -> Store<State, Action>) {
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
            let waitDelaySeconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + waitDelaySeconds) {
                store.dispatch(.didAppear)
            }
        }
    }
}

#Preview {
    SplashView {
        .init(initial: .init())
    }
}
