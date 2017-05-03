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

    /**
     * 連線狀態
     * ScanFinish,			//掃描結束
     * Connected,			//連線成功
     * Disconnected,		//斷線
     * ConnectTimeout,		//連線超時
     */
    
/*
    func onBtStateChanged(_ isEnable: Bool) {
        if isEnable == false{
            print("ＯＰＥＮＢＬＥ")
            
        }else {
            
            print("ALREADYHere")
        }
    }
    func onConnectionState(_ state: ConnectState) {
        print("誒誒")
    }

    var BLEprotocol = FuelProtocol()
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        if name == "Power Grip"{
            BLEprotocol.connectUUID(uuid)
          //  BLEprotocol.stopScan()
        }
        
        
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(toConnect), with: nil, afterDelay: 3)

//        BLEprotocol = BLEprotocol.getInstanceSimulation(false, printLog: true) as! FuelProtocol
//        
//        BLEprotocol.connectStateDelegate = self as! ConnectStateDelegate
 //       BLEprotocol.dataResponseDelegate = self as! DataResponseDelegate
        
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
