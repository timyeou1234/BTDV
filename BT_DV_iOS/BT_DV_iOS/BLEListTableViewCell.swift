//
//  BLEListTableViewCell.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class BLEListTableViewCell: UITableViewCell {

    @IBOutlet weak var bleNameLabel: UILabel!
    
    @IBOutlet weak var bleUUIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
