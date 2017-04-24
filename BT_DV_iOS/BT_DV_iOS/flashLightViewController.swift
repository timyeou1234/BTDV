//
//  flashLightViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/24.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class flashLightViewController: UIViewController {

    @IBOutlet weak var flashLightTableViewDetail: UITableView!
    
    let  flashLightNameArray = ["自動","補光閃光燈","消除紅眼","關","手電筒模式"]
    let flashLightPicArray = ["btn_flash_auto_1","btn_flash_on_1","btn_flash_redeye_1","btn_flash_off_1","btn_flash_light_1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flashLightTableViewDetail.delegate = self
        self.flashLightTableViewDetail.dataSource = self
        let nib = UINib(nibName: "flashtLightTableViewCell", bundle: nil)
        self.flashLightTableViewDetail.register(nib, forCellReuseIdentifier: "flashLightTableViewCell")
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashLightNameArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "閃光燈"
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashLightTableViewCell", for: indexPath) as? flashtLightTableViewCell
        cell?.flashLightPic.image = UIImage(named:flashLightPicArray[indexPath.row])
        cell?.flahLightName.text = flashLightNameArray[indexPath.row]
        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        performSegue(withIdentifier: "unwindFromFlashWithSegue", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromFlashWithSegue"{
            let vca: ViewController? = (segue.destination as? ViewController)
            //           let selectedPath: IndexPath? = senceTableViewDetail.indexPath(for: sender as! UITableViewCell)
            print(sender)
            vca?.flashLightTableView.isHidden = true
            
        }
        /*
         if let seletRow = senceTableViewDetail.indexPathForSelectedRow?.row{
         let sendThis = senceNameArray[seletRow]
         if segue.identifier == "showDetail"{}
         if let detail = segue.destination as? ViewController{
         
         
         
         }
         }
         */
    }
    



}