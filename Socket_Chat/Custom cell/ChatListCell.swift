//
//  ChatListCell.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet var imgvw: UIImageView!
    @IBOutlet var contactNm: UILabel!
    @IBOutlet var lstmsg: UILabel!
    @IBOutlet var msgcount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
