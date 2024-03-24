//
//  UIViewControllerRepresentableBuilder.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//

import SwiftUI

struct UIViewControllerRepresentableBuilder<T: UIViewController>: UIViewControllerRepresentable {
    let builderFunc: () -> T

    func makeUIViewController(context: Context) -> T {
        builderFunc()
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {
    }
}
