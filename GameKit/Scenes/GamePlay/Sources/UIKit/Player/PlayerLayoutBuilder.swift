//
//  PlayerLayoutBuilder.swift
//
//  Created by Hugues Stephano Telolahy on 04/04/2020.
//
// swiftlint:disable no_magic_numbers multiline_arguments_brackets

import UIKit

enum PlayerLayoutBuilder {
    static func buildLayout(for playersCount: Int, size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        switch playersCount {
        case 2:
            return buildLayoutFor2Players(size: size, padding: padding)

        case 3:
            return buildLayoutFor3Players(size: size, padding: padding)

        case 4:
            return buildLayoutFor4Players(size: size, padding: padding)

        case 5:
            return buildLayoutFor5Players(size: size, padding: padding)

        case 6:
            return buildLayoutFor6Players(size: size, padding: padding)

        case 7:
            return buildLayoutFor7Players(size: size, padding: padding)

        default:
            fatalError("Illegal state")
        }
    }
}

private extension PlayerLayoutBuilder {
    static func buildLayoutFor2Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        result[1] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: padding,
                           width: cellSize.width,
                           height: cellSize.height)

        return result
    }

    static func buildLayoutFor3Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        let topItemsCount = 3
        let topFrames = topItemsFrames(for: topItemsCount, size: size, padding: padding)
        result[1] = topFrames[0]
        result[2] = topFrames[2]

        return result
    }

    static func buildLayoutFor4Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        result[1] = CGRect(x: padding,
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        result[2] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: padding,
                           width: cellSize.width,
                           height: cellSize.height)

        result[3] = CGRect(x: (size.width - cellSize.width - padding),
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        return result
    }

    static func buildLayoutFor5Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        result[1] = CGRect(x: padding,
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        result[4] = CGRect(x: (size.width - cellSize.width - padding),
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        let topItemsCount = 2
        let topFrames = topItemsFrames(for: topItemsCount, size: size, padding: padding)
        Array(0..<topItemsCount).forEach { result[$0 + 2] = topFrames[$0] }

        return result
    }

    static func buildLayoutFor6Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        result[1] = CGRect(x: padding,
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        result[5] = CGRect(x: (size.width - cellSize.width - padding),
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        let topItemsCount = 3
        let topFrames = topItemsFrames(for: topItemsCount, size: size, padding: padding)
        Array(0..<topItemsCount).forEach { result[$0 + 2] = topFrames[$0] }

        return result
    }

    static func buildLayoutFor7Players(size: CGSize, padding: CGFloat) -> [Int: CGRect] {
        var result: [Int: CGRect] = [:]

        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)

        result[0] = CGRect(x: (size.width - cellSize.width) / 2,
                           y: (size.height - cellSize.height - padding),
                           width: cellSize.width,
                           height: cellSize.height)

        result[1] = CGRect(x: padding,
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        result[6] = CGRect(x: (size.width - cellSize.width - padding),
                           y: (size.height - cellSize.height) / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        let topItemsCount = 4
        let topFrames = topItemsFrames(for: topItemsCount, size: size, padding: padding)
        Array(0..<topItemsCount).forEach { result[$0 + 2] = topFrames[$0] }

        return result
    }

    static func topItemsFrames(for topItemsCount: Int, size: CGSize, padding: CGFloat) -> [CGRect] {
        let cellSize = CGSize(width: (size.width - padding * 5) / 4,
                              height: (size.height - padding * 4) / 3)
        let topSpacing = (size.width - (CGFloat(topItemsCount)) * cellSize.width) / CGFloat(topItemsCount + 1)
        return Array(0..<topItemsCount).map {
            CGRect(x: topSpacing + (topSpacing + cellSize.width) * CGFloat($0),
                   y: padding,
                   width: cellSize.width,
                   height: cellSize.height)
        }
    }
}
