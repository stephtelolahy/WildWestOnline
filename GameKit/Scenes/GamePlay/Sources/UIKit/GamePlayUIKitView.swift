//
//  GamePlayUIKitView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
import AppCore
import Redux
import SwiftUI

public struct GamePlayUIKitView: UIViewControllerRepresentable {
    @StateObject private var store: Store<GamePlayView.State>

    public init(store: @escaping () -> Store<GamePlayView.State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public func makeUIViewController(context: Context) -> GamePlayViewController {
        GamePlayViewController(nibName: "GamePlayViewController", bundle: .module)
    }

    public func updateUIViewController(_ uiViewController: GamePlayViewController, context: Context) {
    }
}

#Preview {
    GamePlayUIKitView {
        Store<GamePlayView.State>(initial: previewState)
    }
}

private var previewState: GamePlayView.State {
    .init(
        visiblePlayers: [],
        message: "",
        chooseOneActions: [:],
        handActions: [],
        events: []
    )
}
