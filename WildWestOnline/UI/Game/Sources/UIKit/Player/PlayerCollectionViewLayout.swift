//
//  PlayerCollectionViewLayout.swift
//
//  Created by Hugues Stephano Telolahy on 04/04/2020.
//

import UIKit

protocol PlayerCollectionViewLayoutDelegate: AnyObject {
    @MainActor func numberOfItemsForGameCollectionViewLayout( layout: PlayerCollectionViewLayout) -> Int
}

class PlayerCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: PlayerCollectionViewLayoutDelegate?

    // An array to cache the calculated attributes
    private var cache: [UICollectionViewLayoutAttributes] = []

    private let cellPadding: CGFloat = 16

    // Setting the content size
    override var collectionViewContentSize: CGSize {
        guard let collectionView else {
            fatalError("Illegal state")
        }

        let insets = collectionView.contentInset
        let bounds = collectionView.bounds
        return CGSize(
            width: bounds.width - (insets.left + insets.right),
            height: bounds.height - (insets.left + insets.right)
        )
    }

    override func prepare() {
        // We begin measuring the location of items only if the cache is empty
        guard cache.isEmpty,
              let numberOfItems = delegate?.numberOfItemsForGameCollectionViewLayout(layout: self) else {
            return
        }

        let cellFrames = PlayerLayoutBuilder.buildLayout(
            for: numberOfItems,
            size: collectionViewContentSize,
            padding: cellPadding
        )

        for item in 0..<numberOfItems {
            if let frame = cellFrames[item] {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
            }
        }
    }

    // Is called  to determine which items are visible in the given rect
    // swiftlint:disable:next discouraged_optional_collection
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        // Loop through the cache and look for items in the rect
        for attribute in cache where attribute.frame.intersects(rect) {
            visibleLayoutAttributes.append(attribute)
        }

        return visibleLayoutAttributes
    }

    // The attributes for the item at the indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.item]
    }
}
