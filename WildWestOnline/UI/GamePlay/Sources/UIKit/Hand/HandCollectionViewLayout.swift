//
//  HandCollectionViewLayout.swift
//
//  Created by Hugues Stephano Telolahy on 04/04/2020.
//
// swiftlint:disable no_magic_numbers multiline_arguments_brackets

import UIKit

class HandCollectionViewLayout: UICollectionViewFlowLayout {
    private let cardRatio: CGFloat

    init(cardRatio: CGFloat) {
        self.cardRatio = cardRatio
        super.init()
    }

    // swiftlint:disable:next unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout Overrides

    override func prepare() {
        super.prepare()

        self.scrollDirection = .horizontal

        guard let collectionView else {
            return
        }

        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: minimumInteritemSpacing,
                                                   bottom: 0,
                                                   right: minimumInteritemSpacing)

        let availableHeight = collectionView.bounds.height

        let spacing: CGFloat = self.minimumInteritemSpacing
        let cellHeight: CGFloat = availableHeight - 2 * spacing
        let cellWidth: CGFloat = cellHeight * cardRatio

        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromSafeArea
        }
    }
}
