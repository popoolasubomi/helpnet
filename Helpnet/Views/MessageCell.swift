//
//  MessageCell.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
