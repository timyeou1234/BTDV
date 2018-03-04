//
//  senceViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/23.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class senceViewController: UIViewController {
    
    //MARK:  Need Localization
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
    let sencePicArray = ["btn_scene_auto_3","btn_scene_action_1","btn_scene_portrait_1","btn_scene_landscape_1","btn_scene_night_1","btn_scene_night_portrait_1","btn_scene_theatre_1","btn_scene_beach_1","btn_scene_snow_1","btn_scene_sunset_1","btn_scene_steady_photo_1","btn_scene_firework_1","btn_scene_sports_1","btn_scene_party_1","btn_scene_candlelight_1"]
    let appl = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var testView: UIImageView!
    @IBOutlet weak var senceTableViewDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senceTableViewDetail.delegate = self
        self.senceTableViewDetail.dataSource = self
        let nib = UINib(nibName: "senceTableViewCell", bundle: nil)
        self.senceTableViewDetail.register(nib, forCellReuseIdentifier: "senceTableViewCell")
        self.senceTableViewDetail.separatorStyle = .none
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postSence"), object:appl.valueFromScene, queue: nil) { notification in
            self.senceTableViewDetail.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension senceViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senceNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "senceTableViewCell", for: indexPath) as? senceTableViewCell
        
        if appl.valueFromScene == nil && indexPath.row == 0{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.senceName.textColor = UIColor.black
        }else if appl.valueFromScene == indexPath{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.senceName.textColor = UIColor.black
        }else{
            cell?.contentView.backgroundColor = UIColor.black
            cell?.senceName.textColor = UIColor.white
        }
        
        cell?.senceName.text = senceNameArray[indexPath.row]
        cell?.senceIcon.image = UIImage(named: sencePicArray[indexPath.row])
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.valueFromScene = indexPath
        
        NotificationCenter.default.post(name: NSNotification.Name("postSence"), object: indexPath)
        tableView.reloadData()
        //        performSegue(withIdentifier: "unwindToVC", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToVC"{
            let vca: ViewController? = (segue.destination as? ViewController)
            vca?.senceTableView.isHidden = true
            vca?.beSelect = true
        }
    }
    
}
