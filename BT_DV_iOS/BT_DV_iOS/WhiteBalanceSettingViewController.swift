//
//  WhiteBalanceSettingViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class WhiteBalanceSettingViewController: UIViewController {

    @IBOutlet weak var whiteBalanceTableView: UITableView!
    var whiteBalanceName = ["自動(AWB)","陰暗","陰天","晴天","日光燈","鎢絲燈","黃昏","暖光燈"]
    var whiteBalanceValue = ["btn_wb_awb_2","btn_wb_shade_1","btn_wb_cloudy_1","btn_wb_daylight_1","btn_wb_fluorescent_1","btn_wb_incandescent_1","btn_wb_twilight_1","btn_wb_warm_fluorescent_1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.whiteBalanceTableView.delegate = self
        self.whiteBalanceTableView.dataSource = self
        self.whiteBalanceTableView.separatorStyle = .none
        
        
        let nib = UINib(nibName: "senceTableViewCell", bundle: nil)
        self.whiteBalanceTableView.register(nib, forCellReuseIdentifier: "senceTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
extension WhiteBalanceSettingViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whiteBalanceName.count
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     }
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "白平衡"
        
    }
/*
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        let imageViewGame = UIImageView(frame: CGRect(5, 8, 40, 40));
        let image = UIImage(named: "btn_back_2");
        imageViewGame.image = image;
        header.contentView.addSubview(imageViewGame)
    }
  */
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UITableViewHeaderFooterView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        v.addGestureRecognizer(tapRecognizer)
        return v
    }
    
    
    func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
        //      self.view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "senceTableViewCell", for: indexPath) as? senceTableViewCell
        cell?.senceName.text = whiteBalanceName[indexPath.row]
        cell?.senceIcon.image = UIImage(named: whiteBalanceValue[indexPath.row])
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.valueFromWhiteBalance = indexPath
        
        NotificationCenter.default.post(name: NSNotification.Name("postWhiteBalance"), object: indexPath)

        
        performSegue(withIdentifier: "unwindFromnWBWithSegue", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromnWBWithSegue"{
            if let indexPath = self.whiteBalanceTableView.indexPathForSelectedRow {
                
                if let vc = segue.destination as? settingViewController{
                    vc.whiteBalanceSetting = whiteBalanceName[indexPath.row]
                    vc.settingTableView.reloadData()
                }
            }
        }
        
        
        
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
        
    }
    
    
    
}
/*
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
*/

