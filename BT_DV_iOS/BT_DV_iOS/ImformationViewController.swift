//
//  ImformationViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/16.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class ImformationViewController: UIViewController {
    
    //MARK: 版本控制
    let fwVersion = "1.5"
    @IBOutlet weak var imformationTableView: UITableView!
    @IBOutlet weak var switchButton: UIButton!
    
    @IBAction func switchBTDV(_ sender: Any) {
        BLEObject.BLEobj.ble?.disconnect()
        NotificationCenter.default.post(name: NSNotification.Name("FailConnect"), object: BLEObject.BLEobj)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imformationTableView.dataSource = self
        imformationTableView.delegate = self
        let nib = UINib(nibName: "senceTableViewCell", bundle: nil)
        self.imformationTableView.register(nib, forCellReuseIdentifier: "senceTableViewCell")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postBattery"), object:nil, queue: nil) { notification in
            self.imformationTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateComplete"), object:nil, queue: nil) { notification in
            self.imformationTableView.isHidden = false
            self.switchButton.isHidden = false
        }
        // Do any additional setup after loading the view.
        
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

extension ImformationViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 && BLEObject.BLEobj.ble?.getFwVersion() != fwVersion{
            //switchButton.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "updateFirmwareViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        }else if indexPath.row == 4{
            BLEObject.BLEobj.ble?.disconnect()
            NotificationCenter.default.post(name: NSNotification.Name("FailConnect"), object: BLEObject.BLEobj)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BTDV"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "senceTableViewCell", for: indexPath) as? senceTableViewCell
        cell?.senceIcon.image = nil
        switch indexPath.row {
        case 0:
            if let name = BLEObject.BLEobj.bleDetail?.bleName{
                cell?.senceName.text = "名稱 \(name)"
            }
            
        case 1:
            if let name = BLEObject.BLEobj.ble?.getHwVersion(){
                cell?.senceName.text = "硬體版本 \(name)"
            }
        case 2:
            if let name = BLEObject.BLEobj.ble?.getFwVersion(){
                cell?.senceName.text = "韌體版本 \(name)"
            }
            if BLEObject.BLEobj.ble?.getFwVersion() != fwVersion{
                cell?.senceIcon.image = #imageLiteral(resourceName: "btn_downlaod_1")
            }
        case 3:
            if let battery = BLEObject.BLEobj.ble?.getBattery(){
                cell?.senceName.text = "電源 \(battery) %"
            }
        default:
            cell?.senceName.text = "關閉BTDV"
            
        }
        
        return cell!
        
        
    }
}
