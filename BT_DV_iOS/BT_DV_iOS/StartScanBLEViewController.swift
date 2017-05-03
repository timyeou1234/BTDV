//
//  StartScanBLEViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class StartScanBLEViewController: UIViewController {

    func toConnect(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetBlueToothInfoViewController") as! GetBlueToothInfoViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.view.viewWithTag(100)
        popOverVC.didMove(toParentViewController: self)

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.perform(#selector(toConnect), with: nil, afterDelay: 5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }
