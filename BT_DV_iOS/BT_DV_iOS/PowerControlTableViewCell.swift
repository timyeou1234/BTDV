//
//  PowerControlTableViewCell.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class PowerControlTableViewCell: UITableViewCell {

    @IBOutlet weak var powerControlLabel: UILabel!
    
    
    @IBOutlet weak var powerContolValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView()
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView!.backgroundColor = selected ?  #colorLiteral(red: 0.6514335275, green: 0.8867900968, blue: 0.1454202831, alpha: 1) : nil

        // Configure the view for the selected state
    }
    
}
