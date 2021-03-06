//
//  MessageTableViewCell.swift
//  ChatSocketGettingStarted
//
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(name: String, message: String) {
        self.senderNameLabel.text = name
        self.messageLabel.text = message
    }
    
}
