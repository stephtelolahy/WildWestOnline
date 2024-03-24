//
//  UIViewControllerRepresentableBuilder.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//

import SwiftUI

struct UIViewControllerRepresentableBuilder<T: UIViewController>: UIViewControllerRepresentable {
    let builder: () -> T

    func makeUIViewController(context: Context) -> T {
        builder()
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {
    }
}
