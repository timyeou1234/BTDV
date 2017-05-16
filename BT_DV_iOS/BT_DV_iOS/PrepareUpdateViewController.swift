//
//  PrepareUpdateViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/16.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import CoreBluetooth
import iOSDFULibrary

class PrepareUpdateViewController: UIViewController ,CBCentralManagerDelegate{

    static var legacyDfuServiceUUID  = CBUUID(string: "00001530-1212-EFDE-1523-785FEABCD123")
    static var secureDfuServiceUUID  = CBUUID(string: "FE59")
    static var deviceInfoServiceUUID = CBUUID(string: "180A")
    
    var isUpdating = false
    var centralManager              : CBCentralManager?
    var selectedPeripheral          : CBPeripheral?
    var selectedPeripheralIsSecure  : Bool?
    var discoveredPeripherals       : [CBPeripheral]
    var securePeripheralMarkers     : [Bool?]
    
    var scanningStarted             : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BLEObject.BLEobj.ble?.setUpgradeMode()
        
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
        self.centralManager!.scanForPeripherals(withServices: [
            PrepareUpdateViewController.legacyDfuServiceUUID,
            PrepareUpdateViewController.secureDfuServiceUUID,
            PrepareUpdateViewController.deviceInfoServiceUUID])
        }
    }

    //MARK: - UIViewController implementation
    required init?(coder aDecoder: NSCoder) {
        discoveredPeripherals   = [CBPeripheral]()
        securePeripheralMarkers = [Bool?]()
        super.init(coder: aDecoder)
        centralManager = CBCentralManager(delegate: self, queue: nil) // The delegate must be set in init in order to work on iOS 8
        self.centralManager!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CBCentralManagerDelegate API
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Ignore dupliactes.
        // They will not be reported in a single scan, as we scan without CBCentralManagerScanOptionAllowDuplicatesKey flag,
        // but after returning from DFU view another scan will be started.
       // guard discoveredPeripherals.contains(peripheral) == false else { return }
        
        if advertisementData[CBAdvertisementDataServiceUUIDsKey] != nil {
            
            let name = peripheral.name ?? "Unknown"
            
            let secureUUIDString = PrepareUpdateViewController.secureDfuServiceUUID.uuidString
            let legacyUUIDString = PrepareUpdateViewController.legacyDfuServiceUUID.uuidString
            let advertisedUUIDstring = ((advertisementData[CBAdvertisementDataServiceUUIDsKey]!) as AnyObject).firstObject as! CBUUID
            
            if advertisedUUIDstring.uuidString == secureUUIDString {
                print("Found Secure Peripheral: \(name)")
                discoveredPeripherals.append(peripheral)
                securePeripheralMarkers.append(true)
               
            } else if advertisedUUIDstring.uuidString == legacyUUIDString {
                print("Found Legacy Peripheral: \(name)")
                discoveredPeripherals.append(peripheral)
                securePeripheralMarkers.append(false)
                
                
            } else {
                print("Found Peripheral: \(name)")
                discoveredPeripherals.append(peripheral)
                securePeripheralMarkers.append(nil)
            }
            let dfuViewController = self.storyboard?.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
            self.addChildViewController(dfuViewController)
            dfuViewController.didMove(toParentViewController: self)
            dfuViewController.view.frame = self.view.frame
            dfuViewController.secureDFUMode(true)
            dfuViewController.setTargetPeripheral(peripheral)
            dfuViewController.setCentralManager(centralManager!)
            self.view.addSubview((dfuViewController.view)!)
        }
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
