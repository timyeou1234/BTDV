//
//  flashLightViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/24.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit


class flashLightViewController: UIViewController {

    
    var valueIGot = ""
    @IBOutlet weak var flashLightTableViewDetail: UITableView!
    
    let  flashLightNameArray = ["自動","補光閃光燈","消除紅眼","關","手電筒模式"]
    let flashLightPicArray = ["btn_flash_auto_1","btn_flash_on_1","btn_flash_redeye_1","btn_flash_off_1","btn_flash_light_1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flashLightTableViewDetail.delegate = self
        self.flashLightTableViewDetail.dataSource = self
        
        self.flashLightTableViewDetail.separatorStyle = .none

        //註冊xib
        let nib = UINib(nibName: "flashtLightTableViewCell", bundle: nil)
        self.flashLightTableViewDetail.register(nib, forCellReuseIdentifier: "flashLightTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension flashLightViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashLightNameArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashLightTableViewCell", for: indexPath) as? flashtLightTableViewCell
        let appl = UIApplication.shared.delegate as! AppDelegate
        if appl.valueFromFlash == nil && indexPath.row == 3{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.flahLightName.textColor = UIColor.black
        }else if appl.valueFromFlash == indexPath{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.flahLightName.textColor = UIColor.black
        }else{
            cell?.contentView.backgroundColor = UIColor.black
            cell?.flahLightName.textColor = UIColor.white
        }

        cell?.flashLightPic.image = UIImage(named:flashLightPicArray[indexPath.row])
        cell?.flahLightName.text = flashLightNameArray[indexPath.row]
        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.valueFromFlash = indexPath
        
        NotificationCenter.default.post(name: NSNotification.Name("postFlash"), object: indexPath)

        flashLightTableViewDetail.reloadData()
        performSegue(withIdentifier: "unwindFromFlashWithSegue", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromFlashWithSegue"{
            if let indexPath = self.flashLightTableViewDetail.indexPathForSelectedRow {

            let vca: ViewController? = (segue.destination as? ViewController)

            vca?.flashLightTableView.isHidden = true
            }
        }
    }
    



}
