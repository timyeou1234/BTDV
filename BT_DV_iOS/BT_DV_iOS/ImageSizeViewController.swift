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
    
    var imageSizeDetail = ["90萬(1280*720)","200萬(1920*1080)","300萬(2048*1536)","600萬(3264*1836)","800萬(3264*2448)"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageSizeDetailTableView.delegate = self
        self.imageSizeDetailTableView.dataSource = self
        self.imageSizeDetailTableView.separatorStyle = .none
        
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSizeDetail.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "影像尺寸"
        
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
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSizeDetailTableViewCell", for: indexPath) as? ImageSizeDetailTableViewCell
        cell?.imageSizeLabel.text = imageSizeDetail[indexPath.row]
        
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
        
    }
    
    
    
    
}
