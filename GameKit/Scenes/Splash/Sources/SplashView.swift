//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Redux
import SwiftUI
import AppCore

public struct SplashView: View {
    private enum Constant {
        static let waitDelaySeconds = 2.0
    }

    @StateObject private var store: Store<SplashState>

    public init(store: @escaping () -> Store<SplashState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
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
            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.waitDelaySeconds) {
                store.dispatch(AppAction.navigate(.home))
            }
        }
    }
}

#Preview {
    SplashView {
        Store<SplashState>(initial: .init())
    }
}
