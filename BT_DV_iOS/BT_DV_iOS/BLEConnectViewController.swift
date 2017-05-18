//
//  BLEConnectViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class BLEConnectViewController: UIViewController {
    
    var count = 0
    @IBOutlet weak var searchingImageView: UIImageView!
    
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
        count = 0
        startRotate()
        
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
            count = 21
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PowerGripStatusViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        case Disconnect, ConnectTimeout:
            count = 21
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
    
    func startRotate(){
        if count < 20{
            UIView.animate(withDuration: 0.5, animations: {
                self.searchingImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }, completion: {
                sucess in
                UIView.animate(withDuration: 0.5, animations: {
                    self.searchingImageView.transform = CGAffineTransform(rotationAngle: 0)
                }, completion: {
                    sucess in
                    self.count += 1
                    self.startRotate()
                })
            })
        }
    }

    
}

