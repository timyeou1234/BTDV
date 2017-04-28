//
//  MainSettingTwoTableViewCell.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class MainSettingTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var settingNameTwoLabel: UILabel!
    
    @IBOutlet weak var tapForTakePhoto: UISwitch!
    
  //  let controller = storyboard.instantiateViewController(withIdentifier: "ShelfTableViewController") as! ShelfTableViewController
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
