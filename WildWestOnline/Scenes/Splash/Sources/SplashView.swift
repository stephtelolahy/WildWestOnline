//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

import AppCore
import Redux
import SwiftUI

public struct SplashView: View {
    @StateObject private var store: StoreV1<State>

    public init(store: @escaping () -> StoreV1<State>) {
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
        .onAppear {
            let waitDelaySeconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + waitDelaySeconds) {
                store.dispatch(AppAction.navigate(.home))
            }
        }
    }
}

#Preview {
    SplashView {
        StoreV1(initial: .init())
    }
}
