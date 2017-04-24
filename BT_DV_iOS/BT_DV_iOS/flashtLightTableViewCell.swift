//
//  flashtLightTableViewCell.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/24.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class flashtLightTableViewCell: UITableViewCell {

    @IBOutlet weak var flashLightPic: UIImageView!
    
    @IBOutlet weak var flahLightName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
