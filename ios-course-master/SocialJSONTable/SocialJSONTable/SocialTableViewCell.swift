//
//  SocialTableViewCell.swift
//  SocialJSONTable
//
//  Created by Kevin Harris on 9/7/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

    @IBOutlet weak var socialIcon: UIImageView!
    @IBOutlet weak var sharesText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
