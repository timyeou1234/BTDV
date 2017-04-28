//
//  settingViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/25.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class settingViewController: UIViewController {
    
    var sendTag = 10
    let settingNameArrayOne = ["場景選擇","白平衡","曝光補償"]
    var settingNameArrayTwo = ["觸碰拍攝"]

    var senceSetting = "自動"
    var whiteBalanceSetting = "自動ＡＷＢ"
    var evValue = ""
    
    var imageSize = "800萬(3264*2448)"
    var powerstatus = "2分鐘自動關機"
    
    var imageSizeSettingName = ["影像尺寸"]
    var imageSizeSettingValue = ["800萬(3264*2448)"]
    
    var powerControlName = ["電源管理"]
    var powerControlValue = ["2分鐘自動關機"]
    
    
    @IBAction func unwindFromSence(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromnWB(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromSize(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromPower(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromEV(segue:UIStoryboardSegue) { }



    var getTapOrNot = false



    @IBOutlet weak var settingTableView: UITableView!
    @IBAction func buttonForSetting(_ sender: UIButton) {
        switch (sender.tag){
        case 10:
            sendTag = sender.tag
            self.settingTableView.reloadData()
            break
        case 20:
            sendTag = sender.tag
            self.settingTableView.reloadData()

            break
        case 30:
            sendTag = sender.tag
            self.settingTableView.reloadData()

            break
        default:
            break
        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.separatorStyle = .none

        
        let nib = UINib(nibName: "MainSettingTableViewCell", bundle: nil)
        self.settingTableView.register(nib, forCellReuseIdentifier: "MainSettingTableViewCell")
        let nib2 = UINib(nibName: "MainSettingTwoTableViewCell", bundle: nil)
        self.settingTableView.register(nib2, forCellReuseIdentifier: "MainSettingTwoTableViewCell")
        
        let nib3 = UINib(nibName: "ImageSizeTableViewCell", bundle: nil)
        self.settingTableView.register(nib3, forCellReuseIdentifier: "ImageSizeTableViewCell")
        
        let nib4 = UINib(nibName: "PowerControlTableViewCell", bundle: nil)
        self.settingTableView.register(nib4, forCellReuseIdentifier: "PowerControlTableViewCell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchChanged(_ sender: Any) {
        let switchControl: UISwitch? = sender as! UISwitch
        print("The switch is \((switchControl?.isOn)! ? "ON" : "OFF")")
    }



}

extension settingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (sendTag){
        case 10:

        return 4
        case 20:
            return imageSizeSettingName.count
            
        case 30:
            return powerControlName.count
            
        default:
            
            print("Error")
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (sendTag){
        case 10:
            if indexPath.row == 3{
                var cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTwoTableViewCell", for: indexPath) as? MainSettingTwoTableViewCell
                if cell == nil{
                    cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "SwitchCell") as! MainSettingTwoTableViewCell
                    cell?.textLabel?.text = "I Have A Switch"
   //                 cell?.selectionStyle = []
                    let switchView = UISwitch(frame: CGRect.zero)
                    cell?.accessoryView = switchView
                    switchView.setOn(false, animated: false)
                    switchView.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)

                
                
                }
                
                cell?.settingNameTwoLabel.text = "觸碰拍攝"
               cell?.tapForTakePhoto.isOn = false
                self.getTapOrNot = (cell?.tapForTakePhoto.isOn)!
 //               settingNameArrayTwo[indexPath.row]
 //               cell?.switchImage.image = UIImage(named:"btn_flash_auto_1")
                //            cell?.flashLightPic.image = UIImage(named:flashLightPicArray[indexPath.row])
                //            cell?.flahLightName.text = flashLightNameArray[indexPath.row]
                
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTableViewCell", for: indexPath) as? MainSettingTableViewCell
                cell?.settingNameLabel.text = settingNameArrayOne[indexPath.row]
                let arr = [senceSetting,whiteBalanceSetting,evValue]
                cell?.settingValueLabel.text = arr[indexPath.row]
                
                return cell!
            }
        case 20:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeTableViewCell", for: indexPath) as? ImageSizeTableViewCell
            cell?.imageSizeLabel.text = imageSizeSettingName[indexPath.row]
            cell?.imageSizeValueLabel.text = imageSize
            
            return cell!
            break
        case 30:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PowerControlTableViewCell", for: indexPath) as? PowerControlTableViewCell
            cell?.powerControlLabel.text = powerControlName[indexPath.row]
            cell?.powerContolValue.text = powerstatus
            
            return cell!
            
            break
        default:
            break
            
            
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTwoTableViewCell", for: indexPath) as? MainSettingTwoTableViewCell
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && sendTag == 10{
            let vc = storyboard?.instantiateViewController(withIdentifier: "SenceFromSettingViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        
        }else if indexPath.row == 1 && sendTag == 10 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WhiteBalanceSettingViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)

        }else if indexPath.row == 2 && sendTag == 10{
            let vc = storyboard?.instantiateViewController(withIdentifier: "SetEVViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)

        }else if indexPath.row == 3 && sendTag == 10{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
            
            
            vc.tapOrNot = self.getTapOrNot
            print("有沒有收到真假值",vc.tapOrNot)


        }else if indexPath.row == 0 && sendTag == 20{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSizeViewController")
            
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)

        
        }else if indexPath.row == 0 && sendTag == 30{
            let vc = storyboard?.instantiateViewController(withIdentifier: "PowerControlViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)

        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "unwindFromFlashWithSegue"{
//            if let indexPath = self.flashLightTableViewDetail.indexPathForSelectedRow {
//                
//                let vca: ViewController? = (segue.destination as? ViewController)
//                //           let selectedPath: IndexPath? = senceTableViewDetail.indexPath(for: sender as! UITableViewCell)
//                let valueIGot = flashLightPicArray[indexPath.row]
//                
//                vca?.flashToMain = valueIGot
//                print(valueIGot)
//                
//                vca?.flashLightTableView.isHidden = true
//            }
//        }
            }
    

}
