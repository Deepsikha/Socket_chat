//
//  mediaCell.swift
//  Socket_Chat
//
//  Created by devloper65 on 4/11/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class mediaCell: UICollectionViewCell {

    @IBOutlet var imgMedia: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgMedia.layer.cornerRadius = imgMedia.frame.width / 2
        // Initialization code
    }
    
}
