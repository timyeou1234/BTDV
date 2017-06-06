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
    
    @IBOutlet weak var searchingImageView: UIImageView!
    
    var count = 0
    var isContinue = true
    let bleProtoclol = FuelProtocol()
    var childController = UIViewController()
    var isShow = false
    var bleList = [BLEDetail]()
    
    func toConnect(){
        count = 0
        startRotate()
        bleList = [BLEDetail]()
        BLEObject.BLEobj.ble?.startScanTimeout(2)
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
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
            self.isContinue = false
        }

//        BLEObject.BLEobj.ble?.enableBluetooth()
        
        
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BLEObject.BLEobj.ble = bleProtoclol
        BLEObject.BLEobj.ble?.connectStateDelegate = self
        BLEObject.BLEobj.ble?.dataResponseDelegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("toConnect"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            BLEObject.BLEobj.ble = self.bleProtoclol
            BLEObject.BLEobj.ble?.connectStateDelegate = self
            BLEObject.BLEobj.ble?.dataResponseDelegate = self
            self.startAgain()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FailConnectStartAgain"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            BLEObject.BLEobj.ble = self.bleProtoclol
            BLEObject.BLEobj.ble?.connectStateDelegate = self
            BLEObject.BLEobj.ble?.dataResponseDelegate = self
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
        }else{
            BLEObject.BLEobj.state = false
            let alert = UIAlertController(title: "請開啟藍芽", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
            isContinue = false
        }
        
    }
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        if name.contains("FA00000"){
            let detail = BLEDetail()
            detail.bleUUID = uuid
            let nameHere = name.replacingOccurrences(of: "FA00000", with: "Power Grip(") + ")"
            detail.bleName = nameHere
            detail.bleRssi = rssi
            bleList.append(detail)
        }else{
            let detail = BLEDetail()
            detail.bleUUID = uuid
            detail.bleName = name
            detail.bleRssi = rssi
            bleList.append(detail)
        }
    }
    
    func startRotate(){
        if count < 6{
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.searchingImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }) { finished in
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                    self.searchingImageView.transform = CGAffineTransform(rotationAngle: 0)
                }) { finished in
                    self.count += 1
                    self.startRotate()
                }
            }
        }
    }
    
    func onConnectionState(_ state: ConnectState) {
        
    }
    
    func onResponsePressed(_ keyboardCode: Int32) {
        
    }
    
}
