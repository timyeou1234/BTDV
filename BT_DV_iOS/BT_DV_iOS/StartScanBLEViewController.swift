//
//  StartScanBLEViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class StartScanBLEViewController: UIViewController {

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func toConnect(){
        

        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetBlueToothInfoViewController") as! GetBlueToothInfoViewController
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.view.viewWithTag(100)
        popOverVC.didMove(toParentViewController: self)

        

        
        let when = DispatchTime.now() + 6 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }

        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let BlueToothInfo = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetBlueToothInfoViewController") as? GetBlueToothInfoViewController
//        self.present(BlueToothInfo!, animated: false, completion: nil)
        
//        Bleprotoc.BLE.shardBleprotocol?.startScanTimeout(2)
        

        let appl = UIApplication.shared.delegate as! AppDelegate
        print("appl",appl.bleUUID)

//        if appl.bleUUID != []{
//   //         self.perform(#selector(toConnect), with: nil, afterDelay: 2)
//
//        
//        } else{
//            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FailToScanViewController") as! FailToScanViewController
//            
//            self.addChildViewController(popOverVC)
//            popOverVC.view.frame = self.view.frame
//            self.view.addSubview(popOverVC.view)
//            popOverVC.view.viewWithTag(100)
//            popOverVC.didMove(toParentViewController: self)
//
//        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }
