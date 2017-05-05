//
//  BLEConnectViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class BLEConnectViewController: UIViewController {
    
    func toConnect(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PowerGripStatusViewController") as! PowerGripStatusViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        popOverVC.view.viewWithTag(100)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
        
//                    popOverVC.willMove(toParentViewController: nil)
//                    popOverVC.view.removeFromSuperview()
//                    popOverVC.removeFromParentViewController()

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
    }


      override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(toConnect), with: nil, afterDelay: 3)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
