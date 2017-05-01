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
    
    var delegate: cellModelChanged!

    
  //  let controller = storyboard.instantiateViewController(withIdentifier: "ShelfTableViewController") as! ShelfTableViewController
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        tapForTakePhoto.setOn(false, animated: true)
  //      settingNameTwoLabel.text = ""
    }
 
    @IBAction func tapOnOrOffForPhoto(_ sender: Any) {
        
        let invSwitch = sender as! UISwitch
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.tapToTakePhoto = (sender as AnyObject).isOn
        NotificationCenter.default.post(name: NSNotification.Name("postTapOrNot"), object: appl.tapToTakePhoto)
        UserDefaults.standard.set(appl.tapToTakePhoto, forKey: "TapOrNot")
        UserDefaults.standard.synchronize()

        print("按下去與否",(appl.tapToTakePhoto)!)
//        delegate.cellModelSwitchTapped(self, isSwitchOn: invSwitch.isOn)

    }
    
}
