//
//  MessageCell.swift
//
//  Created by Hugues Stéphano TELOLAHY on 2/25/20.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet private weak var messageLabel: UILabel!

    func update(with message: String) {
        messageLabel.text = message
    }
}
