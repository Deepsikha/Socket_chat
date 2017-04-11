//
//  ContactViewCell.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet var imgvw: UIImageView!
    @IBOutlet var usernm: UILabel!
    @IBOutlet var usrstatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
