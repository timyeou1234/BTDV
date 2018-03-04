//
//  settingViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/25.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
protocol cellModelChanged {
    func cellModelSwitchTapped(_ model: MainSettingTwoTableViewCell, isSwitchOn: Bool)
}

class settingViewController: UIViewController {
    
    let appl = UIApplication.shared.delegate as! AppDelegate
    var selectedIndex:IndexPath?
    var getTapOrNot = false
    var sendTag = 10
    //MARK:  Need Localization
    
    let settingNameArrayOne = [
        NSLocalizedString("settingNameArrayOne_SceneSelect", comment: "場景選擇"),
        NSLocalizedString("settingNameArrayOne_Whitebalance", comment: "白平衡"),
        NSLocalizedString("settingNameArrayOne_expose", comment: "曝光補償")]
    var settingNameArrayTwo = [NSLocalizedString("settingNameArrayOne_Touch", comment: "觸碰拍攝")]
    
    var senceNameArray = [
        NSLocalizedString("flashLightNameArray_Auto", comment: "自動"),
        NSLocalizedString("senceNameArray_Move", comment: "行進中"),
        NSLocalizedString("senceNameArray_Portrait", comment: "人像"),
        NSLocalizedString("senceNameArray_Landscape", comment:"風景"),
        NSLocalizedString("senceNameArray_Night", comment:"夜間"),
        NSLocalizedString("senceNameArray_NightPortrait", comment:"夜間人像"),
        NSLocalizedString("senceNameArray_Cinema", comment:"劇院"),
        NSLocalizedString("senceNameArray_Beach", comment:"海灘"),
        NSLocalizedString("senceNameArray_Snow", comment:"雪景") ,
        NSLocalizedString("senceNameArray_Sunset", comment:"夕照"),
        NSLocalizedString("senceNameArray_PreventShake", comment:"防震"),
        NSLocalizedString("senceNameArray_Fireworks", comment:"煙火"),
        NSLocalizedString("senceNameArray_Moving", comment:"運動"),
        NSLocalizedString("senceNameArray_Party", comment:"派對"),
        NSLocalizedString("senceNameArray_Candle", comment:"燭光")]
    
    var senceSetting = NSLocalizedString("flashLightNameArray_Auto", comment: "自動")
    var whiteBalanceSetting = "\(NSLocalizedString("flashLightNameArray_Auto", comment: "自動"))ＡＷＢ"
    var evValue = "0"
    
    var imageSize = "800萬(3264*2448)"
    var powerstatus = "2分鐘自動關機"
    
    var imageSizeSettingName = ["影像尺寸"]
    var imageSizeSettingValue = ["800萬(3264*2448)"]
    
    
    @IBAction func unwindFromSence(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromnWB(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromSize(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromPower(segue:UIStoryboardSegue) { }
    @IBAction func unwindFromEV(segue:UIStoryboardSegue) { }

    @IBOutlet weak var cameraSettingButton: UIButton!
    @IBOutlet weak var qualitySettingButton: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var toolButton: UIButton!
    
    @IBAction func cameraAction(_ sender: Any) {
        setSelectedButton(sender as! UIButton)
        sendTag = 10
        self.settingTableView.reloadData()
    }
    
    @IBAction func qualityAction(_ sender: Any) {
        setSelectedButton(sender as! UIButton)
        sendTag = 20
        self.settingTableView.reloadData()
    }
    
    @IBAction func toolAction(_ sender: Any) {
        setSelectedButton(toolButton)
        sendTag = 30
        self.settingTableView.reloadData()
    }
    
    func setSelectedButton(_ button:UIButton){
        cameraSettingButton.isSelected = false
        qualitySettingButton.isSelected = false
        toolButton.isSelected = false
        button.isSelected = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.separatorStyle = .none
        
        senceNameArray = [
            NSLocalizedString("flashLightNameArray_Auto", comment: "自動"),
            NSLocalizedString("senceNameArray_Move", comment: "行進中"),
            NSLocalizedString("senceNameArray_Portrait", comment: "人像"),
            NSLocalizedString("senceNameArray_Landscape", comment:"風景"),
            NSLocalizedString("senceNameArray_Night", comment:"夜間"),
            NSLocalizedString("senceNameArray_NightPortrait", comment:"夜間人像"),
            NSLocalizedString("senceNameArray_Cinema", comment:"劇院"),
            NSLocalizedString("senceNameArray_Beach", comment:"海灘"),
            NSLocalizedString("senceNameArray_Snow", comment:"雪景") ,
            NSLocalizedString("senceNameArray_Sunset", comment:"夕照"),
            NSLocalizedString("senceNameArray_PreventShake", comment:"防震"),
            NSLocalizedString("senceNameArray_Fireworks", comment:"煙火"),
            NSLocalizedString("senceNameArray_Moving", comment:"運動"),
            NSLocalizedString("senceNameArray_Party", comment:"派對"),
            NSLocalizedString("senceNameArray_Candle", comment:"燭光")]
        
        cameraSettingButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting1_1"), for: .normal)
        cameraSettingButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting1_2"), for: .selected)
        qualitySettingButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting2_1"), for: .normal)
        qualitySettingButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting2_2"), for: .selected)
        toolButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting3_1"), for: .normal)
        toolButton.setImage(#imageLiteral(resourceName: "btn_setting_camera_setting3_2"), for: .selected)

        //註冊所有的xib
        let nib = UINib(nibName: "MainSettingTableViewCell", bundle: nil)
        self.settingTableView.register(nib, forCellReuseIdentifier: "MainSettingTableViewCell")
        
        let nib2 = UINib(nibName: "MainSettingTwoTableViewCell", bundle: nil)
        self.settingTableView.register(nib2, forCellReuseIdentifier: "MainSettingTwoTableViewCell")
        
        let nib3 = UINib(nibName: "ImageSizeTableViewCell", bundle: nil)
        self.settingTableView.register(nib3, forCellReuseIdentifier: "ImageSizeTableViewCell")
        
        let nib4 = UINib(nibName: "PowerControlTableViewCell", bundle: nil)
        self.settingTableView.register(nib4, forCellReuseIdentifier: "PowerControlTableViewCell")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postSence"), object:appl.valueFromScene, queue: nil) { notification in
            self.settingTableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            
        default:
            
            print("Error")
        }
        return 4
    }
    
    //透過sendTag及indexPath.row決定哪一科按鈕的tableView顯示內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (sendTag){
        case 10:
            if selectedIndex == nil && indexPath.row == 0{
                selectedIndex = indexPath
            }
            if indexPath.row == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTwoTableViewCell", for: indexPath) as! MainSettingTwoTableViewCell
                if UserDefaults.standard.value(forKey: "TapOrNot") == nil{
                    cell.tapForTakePhoto.isOn = true
                }else{
                    cell.tapForTakePhoto.isOn = UserDefaults.standard.bool(forKey: "TapOrNot")
                }
                cell.settingNameTwoLabel.text = "觸碰拍攝"
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTableViewCell", for: indexPath) as? MainSettingTableViewCell
                if selectedIndex == indexPath{
                    cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
                    cell?.settingNameLabel.textColor = UIColor.black
                    cell?.settingValueLabel.textColor = UIColor.black
                }else{
                    cell?.contentView.backgroundColor = UIColor.black
                    cell?.settingNameLabel.textColor = UIColor.white
                    cell?.settingValueLabel.textColor = UIColor.white
                }
                cell?.settingNameLabel.text = settingNameArrayOne[indexPath.row]
                var scenen = "自動"
                if let indexFromScenen = appl.valueFromScene{
                    scenen = senceNameArray[indexFromScenen.row]
                }
                let arr = [scenen,whiteBalanceSetting,evValue]
                cell?.settingValueLabel.text = arr[indexPath.row]
                
                return cell!
            }
        case 20:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeTableViewCell", for: indexPath) as? ImageSizeTableViewCell
            cell?.imageSizeLabel.text = imageSizeSettingName[indexPath.row]
            cell?.imageSizeValueLabel.text = imageSize
            
            return cell!
            
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
            if UserDefaults.standard.value(forKey: "TapOrNot") == nil{
                
            }else{
                if UserDefaults.standard.value(forKey: "TapOrNot") as! Bool{
                    UserDefaults.standard.set(false, forKey: "TapOrNot")
                }else{
                    UserDefaults.standard.set(true, forKey: "TapOrNot")
                }
                tableView.reloadData()
            }
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
        
        if sendTag == 10{
            selectedIndex = indexPath
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
