//
//  StartScanBLEViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//
protocol ConnectPressDelegate{
    func press()
}

import UIKit

class StartScanBLEViewController: UIViewController {
    
    let bleProtoclol = FuelProtocol()
    var childController = UIViewController()
    var isShow = false
    var bleList = [BLEDetail]()
    
    func toConnect(){
        BLEObject.BLEobj.ble?.enableBluetooth()
    }
    
    func startAgain(){
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
        bleList = [BLEDetail]()
        toConnect()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLEObject.BLEobj.ble = bleProtoclol
        BLEObject.BLEobj.ble?.connectStateDelegate = self
        BLEObject.BLEobj.ble?.dataResponseDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("toConnect"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            self.toConnect()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FailConnect"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            self.startAgain()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConnecting"{
            let destinationController = segue.destination as! GetBlueToothInfoViewController
            destinationController.bleList = self.bleList
        }
    }
    
}

extension StartScanBLEViewController: ConnectStateDelegate, DataResponseDelegate, ConnectPressDelegate{
    
    func press() {
        
    }
    
    func onBtStateChanged(_ isEnable: Bool) {
        if !isShow {
            return
        }
        if isEnable{
            bleList = [BLEDetail]()
            BLEObject.BLEobj.ble?.startScanTimeout(2)
            let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                if self.bleList.count != 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetBlueToothInfoViewController") as? GetBlueToothInfoViewController
                    vc?.bleList = self.bleList
                    self.addChildViewController(vc!)
                    vc?.didMove(toParentViewController: self)
                    vc?.view.frame = self.view.frame
                    self.childController = vc!
                    self.view.addSubview((vc?.view)!)
                    
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailToScanViewController")
                    self.addChildViewController(vc!)
                    vc?.didMove(toParentViewController: self)
                    vc?.view.frame = self.view.frame
                    self.view.addSubview((vc?.view)!)
                }
            }
        }else{
            BLEObject.BLEobj.state = false
//            NotificationCenter.default.post(name: NSNotification.Name("BLEState"), object: BLEObject.BLEobj)
            let alert = UIAlertController(title: "請開啟藍芽", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        if name == "Power Grip" || name == "DfuTarg"{
            let detail = BLEDetail()
            detail.bleUUID = uuid
            detail.bleName = name
            detail.bleRssi = rssi
            bleList.append(detail)
        }
    }
    
    func onConnectionState(_ state: ConnectState) {
        
    }
    
    func onResponsePressed(_ keyboardCode: Int32) {
        
    }
    
}
