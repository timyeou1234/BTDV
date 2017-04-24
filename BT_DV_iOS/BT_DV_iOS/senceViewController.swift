//
//  senceViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/23.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class senceViewController: UIViewController {
var senceNameArray = ["自動","行進中","人像","風景","夜間","夜間人像","劇院","海灘","雪景","夕照","防震","煙火","運動","派對","燭光"]
    let sencePicArray = ["btn_scene_auto_3","btn_scene_action_1","btn_scene_portrait_1","btn_scene_landscape_1","btn_scene_night_1","btn_scene_night_portrait_1","btn_scene_theatre_1","btn_scene_beach_1","btn_scene_snow_1","btn_scene_sunset_1","btn_scene_steady_photo_1","btn_scene_firework_1","btn_scene_sports_1","btn_scene_party_1","btn_scene_candlelight_1"]
    
    @IBOutlet weak var testView: UIImageView!
    @IBOutlet weak var senceTableViewDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senceTableViewDetail.delegate = self
        self.senceTableViewDetail.dataSource = self
        let nib = UINib(nibName: "senceTableViewCell", bundle: nil)
        self.senceTableViewDetail.register(nib, forCellReuseIdentifier: "senceTableViewCell")
        self.senceTableViewDetail.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension senceViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senceNameArray.count
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }
    */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "場景選擇"
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "senceTableViewCell", for: indexPath) as? senceTableViewCell
        cell?.senceName.text = senceNameArray[indexPath.row]
        let go = UIImage(named: sencePicArray[indexPath.row])
       cell?.senceIcon.image = UIImage(named: sencePicArray[indexPath.row])
        print(go)
        print(sencePicArray[indexPath.row])
            return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        performSegue(withIdentifier: "unwindToVC", sender: Any?.self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToVC"{
            let vca: ViewController? = (segue.destination as? ViewController)
 //           let selectedPath: IndexPath? = senceTableViewDetail.indexPath(for: sender as! UITableViewCell)
            print(sender)
            vca?.senceTableView.isHidden = true

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
