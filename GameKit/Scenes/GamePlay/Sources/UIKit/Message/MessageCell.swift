//
//  MessageCell.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet private weak var messageLabel: UILabel!

    func update(with message: String) {
        messageLabel.text = message
    }
}
