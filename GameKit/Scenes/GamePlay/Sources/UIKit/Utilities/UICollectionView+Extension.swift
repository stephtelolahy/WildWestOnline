//
//  UICollectionView+Extension.swift
//
//  Created by Hugues Stephano Telolahy on 24/01/2020.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Cell not found")
        }
        return cell
    }
}
