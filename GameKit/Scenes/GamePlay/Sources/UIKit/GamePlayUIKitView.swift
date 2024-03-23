//
//  GamePlayUIKitView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
import SwiftUI

public struct GamePlayUIKitView: View {
    public var body: some View {
        GamePlayWrapperView()
    }
}

struct GamePlayWrapperView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GamePlayViewController {
        GamePlayViewController()
    }

    func updateUIViewController(_ uiViewController: GamePlayViewController, context: Context) {
    }
}

#Preview {
    GamePlayUIKitView()
}
