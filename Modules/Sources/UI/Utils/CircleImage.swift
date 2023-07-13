//
//  CircleImage.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//

import SwiftUI

struct CircleImage: View {
    var size: CGFloat = 50.0
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock", bundle: Bundle.module))
    }
}
