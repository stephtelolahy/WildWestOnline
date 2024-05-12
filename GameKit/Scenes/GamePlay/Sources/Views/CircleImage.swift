//
//  CircleImage.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
// swiftlint:disable no_magic_numbers

import SwiftUI

struct CircleImage: View {
    let image: Image
    var size: CGFloat = 50

    var body: some View {
        image
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

#Preview {
    CircleImage(
        image: Image(.turtlerock),
        size: 50
    )
}
