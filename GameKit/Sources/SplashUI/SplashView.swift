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
    private let splashDelaySeconds = 2.0

    @StateObject private var store: Store<SplashState>

    public init(store: @escaping () -> Store<SplashState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("splash.editor.name", bundle: .module)
                .font(.title2)
                .foregroundStyle(.red)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDelaySeconds) {
                store.dispatch(SplashAction.finish)
            }
        }
    }
}

#Preview {
    SplashView {
        Store<SplashState>(initial: .init())
    }
}
