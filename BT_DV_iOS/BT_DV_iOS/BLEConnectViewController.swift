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
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BLEObject.BLEobj.ble?.connectStateDelegate = self
        BLEObject.BLEobj.ble?.dataResponseDelegate = self
        BLEObject.BLEobj.ble?.connectUUID(BLEObject.BLEobj.bleDetail?.bleUUID)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension BLEConnectViewController:ConnectStateDelegate, DataResponseDelegate{
    
    func onBtStateChanged(_ isEnable: Bool) {
    
    }
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
    
    }
    
    func onConnectionState(_ state: ConnectState) {
        switch state {
            
        case ScanFinish:
            
            break
        case Connected:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PowerGripStatusViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        case Disconnect, ConnectTimeout:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailToConnectViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        default:
            break
        }
    }
    
    func onResponsePressed(_ keyboardCode: Int32) {
        
    }
    
}

