//
//  GetBlueToothInfoViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class GetBlueToothInfoViewController: UIViewController {

    @IBOutlet weak var blueToothListTableView: UITableView!

    @IBAction func scanAgain(_ sender: Any) {
        var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.BLEprotocol.startScanTimeout(5)
        self.blueToothListTableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.blueToothListTableView.delegate = self
        self.blueToothListTableView.dataSource = self
       self.blueToothListTableView.separatorStyle = .none

        let nib = UINib(nibName: "BLEListTableViewCell", bundle: nil)
        self.blueToothListTableView.register(nib, forCellReuseIdentifier: "BLEListTableViewCell")
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


extension GetBlueToothInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appl = UIApplication.shared.delegate as! AppDelegate
        return appl.bleName.count
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     }
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "選擇BTDV"
        
    }
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
 */
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UITableViewHeaderFooterView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        v.addGestureRecognizer(tapRecognizer)
        return v
    }
    
    
    func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let appl = UIApplication.shared.delegate as! AppDelegate

        let cell = tableView.dequeueReusableCell(withIdentifier: "BLEListTableViewCell", for: indexPath) as? BLEListTableViewCell
        cell?.bleNameLabel.text = appl.bleName[indexPath.row]
        cell?.bleUUIDLabel.text = appl.bleUUID[indexPath.row]
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BLEConnectViewController")
        self.addChildViewController(vc!)
        vc?.didMove(toParentViewController: self)
        vc?.view.frame = self.view.frame
        vc?.view.viewWithTag(100)
        self.view.addSubview((vc?.view)!)
        

        
 //      performSegue(withIdentifier: "GetBlueToothInfoViewController", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetBlueToothInfoViewController"{
//            if let indexPath = self.powerControlDetailTableView.indexPathForSelectedRow {
//                if let vc = segue.destination as? settingViewController{
//                    vc.powerstatus = powerControlDetail[indexPath.row]
//                    vc.settingTableView.reloadData()
//                }
//            }
        }
        
        
    }
    
    
    
}


