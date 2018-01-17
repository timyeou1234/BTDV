//
//  GetBlueToothInfoViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class GetBlueToothInfoViewController: UIViewController {
    
    var bleList = [BLEDetail]()
    @IBOutlet weak var blueToothListTableView: UITableView!

    @IBAction func scanAgain(_ sender: Any) {
        
        self.willMove(toParentViewController: nil)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name("toConnect"), object: BLEObject.BLEobj)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.blueToothListTableView.delegate = self
        self.blueToothListTableView.dataSource = self
        self.blueToothListTableView.separatorStyle = .none

        let nib = UINib(nibName: "BleListNameTableViewCell", bundle: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bleList.count
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     }
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLEListTableViewCell", for: indexPath) as! BleListNameTableViewCell
        let detail = bleList[indexPath.row]
        cell.bleNameLabel.text = detail.bleName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEObject.BLEobj.bleDetail = bleList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BLEConnectViewController")
        self.addChildViewController(vc!)
        vc?.didMove(toParentViewController: self)
        vc?.view.frame = self.view.frame
        self.view.addSubview((vc?.view)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}


