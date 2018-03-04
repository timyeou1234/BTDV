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
    
    var timer = Timer()
    var isBackgroundScan = true
    var count = 0
    var isContinue = true
    let bleProtoclol = FuelProtocol()
    var childController = UIViewController()
    var isShow = false
    var bleList = [BLEDetail]()
    
    func toConnect(){
        //        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        //        self.view.layer.removeAllAnimations()
        //        self.view.layoutIfNeeded()
        for child in self.childViewControllers{
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        if count > 0{
            count = 7
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.count = 0
                //                self.startRotate()
            }
        }else{
            count = 0
            
        }
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
                self.count = 1
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailToScanViewController")
                self.addChildViewController(vc!)
                vc?.didMove(toParentViewController: self)
                vc?.view.frame = self.view.frame
                self.view.addSubview((vc?.view)!)
                self.count = 0
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
        BLEObject.BLEobj.ble = bleProtoclol
        BLEObject.BLEobj.ble?.enableBluetooth()
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.startScan), userInfo: nil, repeats: true)
        startRotate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if BLEObject.BLEobj.bleDetail?.bleUUID == nil{
            BLEObject.BLEobj.ble = bleProtoclol
            BLEObject.BLEobj.ble?.connectStateDelegate = self
            BLEObject.BLEobj.ble?.dataResponseDelegate = self
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("toConnect"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            BLEObject.BLEobj.ble = self.bleProtoclol
            BLEObject.BLEobj.ble?.connectStateDelegate = self
            BLEObject.BLEobj.ble?.dataResponseDelegate = self
            self.isBackgroundScan = false
            self.startAgain()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FailConnectStartAgain"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            self.childController.willMove(toParentViewController: nil)
            self.childController.view.removeFromSuperview()
            self.childController.removeFromParentViewController()
            BLEObject.BLEobj.ble = self.bleProtoclol
            self.isShow = true
            BLEObject.BLEobj.ble = self.bleProtoclol
            BLEObject.BLEobj.ble?.connectStateDelegate = self
            BLEObject.BLEobj.ble?.dataResponseDelegate = self
            self.isBackgroundScan = false
            self.startAgain()
        }
        
        //MARK:6/13 change
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FailConnectDontStartAgainOk"), object:BLEObject.BLEobj, queue: nil) { notification in
            self.childController.willMove(toParentViewController: nil)
            self.childController.view.removeFromSuperview()
            self.childController.removeFromParentViewController()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FailConnect"), object:BLEObject.BLEobj, queue: nil) {
            notification in
            self.isBackgroundScan = true
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateComplete"), object: BLEObject.BLEobj, queue: nil) { notification in
            self.isBackgroundScan = true
        }
        
        
    }
    
    func startScan(){
        if isBackgroundScan{
            let userDefaults = Foundation.UserDefaults.standard
            if userDefaults.value(forKey: "BTDV") != nil{
                BLEObject.BLEobj.ble = self.bleProtoclol
                BLEObject.BLEobj.ble?.connectStateDelegate = self
                BLEObject.BLEobj.ble?.dataResponseDelegate = self
                BLEObject.BLEobj.ble?.startScanTimeout(3)
            }
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
        count = 0
        if segue.identifier == "toConnecting"{
            let destinationController = segue.destination as! GetBlueToothInfoViewController
            destinationController.bleList = self.bleList
            self.count = 1
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
            //MARK:  Need Localization
            BLEObject.BLEobj.state = false
            let alert = UIAlertController(title: NSLocalizedString("AskBlueTooth", comment:"請開啟藍芽"), message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Comfirm", comment:"確認"), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
            isContinue = false
        }
        
    }
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        var nameHere = name
        if name.contains("FA00000"){
            let detail = BLEDetail()
            detail.bleUUID = uuid
            nameHere = name.replacingOccurrences(of: "FA00000", with: "易拍客(") + ")"
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
        
        let userDefaults = Foundation.UserDefaults.standard
        if userDefaults.value(forKey: "BTDV") != nil{
            if userDefaults.value(forKey: "BTDV") as! String == uuid && isBackgroundScan{
                BLEObject.BLEobj.bleDetail = BLEDetail()
                BLEObject.BLEobj.bleDetail?.bleName = nameHere
                BLEObject.BLEobj.bleDetail?.bleUUID = uuid
                BLEObject.BLEobj.bleDetail?.bleRssi = rssi
                
                BLEObject.BLEobj.ble?.connectUUID(uuid)
                self.isBackgroundScan = false
            }
        }
    }
    
    func startRotate(){
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
    
    func stopRotate(){
        searchingImageView.stopAnimating()
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
            break
        default:
            break
        }
    }
    
    func onResponsePressed(_ keyboardCode: Int32) {
        
    }
    
}
