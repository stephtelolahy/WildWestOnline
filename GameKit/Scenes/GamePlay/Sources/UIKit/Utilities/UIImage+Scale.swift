//
//  UIImage+Scale.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 25/05/2024.
//

import UIKit

extension UIImage {
    func scale(newWidth: CGFloat) -> UIImage {
        guard self.size.width != newWidth else {
            return self
        }

        let scaleFactor = newWidth / self.size.width

        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
