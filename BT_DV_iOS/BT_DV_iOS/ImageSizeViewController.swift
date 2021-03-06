//
//  ImageSizeViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class ImageSizeViewController: UIViewController {
    
    @IBOutlet weak var imageSizeDetailTableView: UITableView!
    @IBAction func dismissAction(_ sender: Any) {
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    //MARK:  Need Localization
    var imageSizeDetail = [
        "90\(NSLocalizedString("tenthousand", comment: "萬"))(1280*720)",
        "200\(NSLocalizedString("tenthousand", comment: "萬"))(1920*1080)",
        "300\(NSLocalizedString("tenthousand", comment: "萬"))(2048*1536)",
        "600\(NSLocalizedString("tenthousand", comment: "萬"))(3264*1836)",
        "800\(NSLocalizedString("tenthousand", comment: "萬"))(3264*2448)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageSizeDetailTableView.delegate = self
        self.imageSizeDetailTableView.dataSource = self
        self.imageSizeDetailTableView.separatorStyle = .none
        
        //註冊xib
        let nib = UINib(nibName: "ImageSizeDetailTableViewCell", bundle: nil)
        self.imageSizeDetailTableView.register(nib, forCellReuseIdentifier: "ImageSizeDetailTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ImageSizeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSizeDetail.count
    }
   
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    
    
    func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeDetailTableViewCell", for: indexPath) as? ImageSizeDetailTableViewCell
        let appl = UIApplication.shared.delegate as! AppDelegate
        if appl.valueFromSize == nil && indexPath.row == 4{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.imageSizeLabel.textColor = UIColor.black
        }else if appl.valueFromSize == indexPath{
            cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 188/255, green: 255/255, blue: 41/255, alpha: 1)
            cell?.imageSizeLabel.textColor = UIColor.black
        }else{
            cell?.contentView.backgroundColor = UIColor.black
            cell?.imageSizeLabel.textColor = UIColor.white
        }
        cell?.imageSizeLabel.text = imageSizeDetail[indexPath.row]
        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.valueFromSize = indexPath
        
        NotificationCenter.default.post(name: NSNotification.Name("postSize"), object: indexPath)
        
        performSegue(withIdentifier: "unwindFromSizeWithSegue", sender: Any?.self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromSizeWithSegue"{
            if let indexPath = self.imageSizeDetailTableView.indexPathForSelectedRow {
                
                if let vc = segue.destination as? settingViewController{
                    vc.imageSize = imageSizeDetail[indexPath.row]
                    vc.settingTableView.reloadData()
                }
            }
        }
        
        
        //因為本身是childView，以下三行是移除自己的方法
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
        
    }
    
    
    
    
}


    
    

