//
//  PowerControlViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class PowerControlViewController: UIViewController {
    
    @IBOutlet weak var powerControlDetailTableView: UITableView!
    var powerControlDetail = ["關","2分鐘後自動關機","5分鐘後自動關機"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.powerControlDetailTableView.delegate = self
        self.powerControlDetailTableView.dataSource = self
        self.powerControlDetailTableView.separatorStyle = .none
        
        
        let nib = UINib(nibName: "ImageSizeDetailTableViewCell", bundle: nil)
        self.powerControlDetailTableView.register(nib, forCellReuseIdentifier: "ImageSizeDetailTableViewCell")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension PowerControlViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return powerControlDetail.count
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     }
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "電源管理"
        
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeDetailTableViewCell", for: indexPath) as? ImageSizeDetailTableViewCell
        cell?.imageSizeLabel.text = powerControlDetail[indexPath.row]
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "unwindFromPowerWithSegue", sender: Any?.self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromPowerWithSegue"{
            if let indexPath = self.powerControlDetailTableView.indexPathForSelectedRow {
                if let vc = segue.destination as? settingViewController{
                    vc.powerstatus = powerControlDetail[indexPath.row]
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

