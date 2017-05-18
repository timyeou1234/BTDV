//
//  PowerGripStatusViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class PowerGripStatusViewController: UIViewController {

    @IBOutlet weak var softVersionLabel: UILabel!
    @IBOutlet weak var powerGripNameLabel: UILabel!
    @IBOutlet weak var hwVersion: UILabel!
    
    var gameTimer: Timer!
    var hwVersionValue : String!
    var softVersionValue :String!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLEObject.BLEobj.ble?.connectStateDelegate = self
        BLEObject.BLEobj.ble?.dataResponseDelegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

        softVersionLabel.text = BLEObject.BLEobj.ble?.getFwVersion()
        powerGripNameLabel.text = BLEObject.BLEobj.bleDetail?.bleName
        hwVersion.text = BLEObject.BLEobj.ble?.getHwVersion()
        print("硬體值",hwVersionValue)
        BLEObject.BLEobj.batteryInfo = BLEObject.BLEobj.ble?.getBattery()
        NotificationCenter.default.post(name: NSNotification.Name("postBatteryOnly"), object: BLEObject.BLEobj)
        gameTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

    }
    
    func runTimedCode() {
        BLEObject.BLEobj.batteryInfo = BLEObject.BLEobj.ble?.getBattery()
        NotificationCenter.default.post(name: NSNotification.Name("postBattery"), object: BLEObject.BLEobj)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameTimer.invalidate()
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

extension PowerGripStatusViewController:ConnectStateDelegate, DataResponseDelegate{
    
    func onBtStateChanged(_ isEnable: Bool) {
        
    }
    
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        
    }
    
    func onConnectionState(_ state: ConnectState) {
        switch state {
            
        case ScanFinish:
            
            break
        case Connected:
            
            break
        case Disconnect, ConnectTimeout:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailToConnectViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
            gameTimer.invalidate()
        default:
            break
        }
    }
    
    func onResponsePressed(_ keyboardCode: Int32) {
        BLEObject.BLEobj.command = keyboardCode
        NotificationCenter.default.post(name: NSNotification.Name("postCommand"), object: BLEObject.BLEobj)
    }
    
}

