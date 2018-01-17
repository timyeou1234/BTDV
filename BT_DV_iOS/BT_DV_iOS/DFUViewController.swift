//
//  DFUViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/16.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
import CoreBluetooth
import iOSDFULibrary
import MBCircularProgressBar

class DFUViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, DFUServiceDelegate, DFUProgressDelegate, LoggerDelegate {
    /// The UUID of the experimental Buttonless DFU Service from SDK 12.
    /// This service is not advertised so the app needs to connect to check if it's on the device's attribute list.
    static let ExperimentalButtonlessDfuUUID = CBUUID(string: "8E400001-F315-4F60-9FB8-838830DAEA50")
    
    //MARK: - Class Properties
    fileprivate var dfuPeripheral    : CBPeripheral?
    fileprivate var dfuController    : DFUServiceController?
    fileprivate var centralManager   : CBCentralManager?
    fileprivate var selectedFirmware : DFUFirmware?
    fileprivate var selectedFileURL  : URL?
    fileprivate var secureDFU        : Bool?
    
    //MARK: - View Outlets
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    //MARK: - Class Implementation
    func secureDFUMode(_ secureDFU: Bool?) {
        self.secureDFU = secureDFU
    }
    
    func setCentralManager(_ centralManager: CBCentralManager) {
        self.centralManager = centralManager
    }
    
    func setTargetPeripheral(_ targetPeripheral: CBPeripheral) {
        self.dfuPeripheral = targetPeripheral
    }
    
    func getBundledFirmwareURLHelper() -> URL? {
        if let _ = secureDFU {
            
            return Bundle.main.url(forResource: "FA00000-V18", withExtension: "zip")!
            
        } else {
            // We need to connect and discover services. The device does not have to advertise with the service UUID.
            return nil
        }
    }
    
    func startDFUProcess() {
        guard dfuPeripheral != nil else {
            print("No DFU peripheral was set")
            return
        }
        
        let dfuInitiator = DFUServiceInitiator(centralManager: centralManager!, target: dfuPeripheral!)
        dfuInitiator.delegate = self
        dfuInitiator.progressDelegate = self
        dfuInitiator.logger = self
        
        // This enables the experimental Buttonless DFU feature from SDK 12.
        // Please, read the field documentation before use.
        dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        
        dfuController = dfuInitiator.with(firmware: selectedFirmware!).start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedFileURL  = getBundledFirmwareURLHelper()
        
        selectedFirmware = DFUFirmware(urlToZipFile: selectedFileURL!)
        startDFUProcess()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _ = dfuController?.abort()
        dfuController = nil
    }
    
    //MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CM did update state: \(central.state.rawValue)")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let name = peripheral.name ?? "Unknown"
        print("Connected to peripheral: \(name)")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let name = peripheral.name ?? "Unknown"
        print("Disconnected from peripheral: \(name)")
    }
    
    //MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // Find DFU Service
        let services = peripheral.services!
        for service in services {
            if service.uuid.isEqual(PrepareUpdateViewController.legacyDfuServiceUUID) {
                secureDFU = false
                break
            } else if service.uuid.isEqual(PrepareUpdateViewController.secureDfuServiceUUID) {
                secureDFU = true
                break
            } else if service.uuid.isEqual(DFUViewController.ExperimentalButtonlessDfuUUID) {
                secureDFU = true
                break
            }
        }
        if secureDFU != nil {
            selectedFileURL  = getBundledFirmwareURLHelper()
            selectedFirmware = DFUFirmware(urlToZipFile: selectedFileURL!)
            startDFUProcess()
        } else {
            print("Disconnecting...")
            centralManager?.cancelPeripheralConnection(peripheral)
            dfuError(DFUError.deviceNotSupported, didOccurWithMessage: "Device not supported")
        }
    }
    
    //MARK: - DFUServiceDelegate
    
    func dfuStateDidChange(to state: DFUState) {
        switch state {
        case .completed, .disconnecting:
            
            break
        case .aborted:
            
            break
        default:
            break
        }
        
        
        print("Changed state to: \(state.description())")
        
        // Forget the controller when DFU is done
        if state == .completed {
            dfuController = nil
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateSuccessViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        }else if state == .aborted && state == .disconnecting{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateFailViewController")
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            vc?.view.frame = self.view.frame
            self.view.addSubview((vc?.view)!)
        }
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateFailViewController")
        self.addChildViewController(vc!)
        vc?.didMove(toParentViewController: self)
        vc?.view.frame = self.view.frame
        self.view.addSubview((vc?.view)!)
    }
    
    //MARK: - DFUProgressDelegate
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                success in
                self.progressView.value = CGFloat(progress)
            })
        }
        
    }
    
    //MARK: - LoggerDelegate
    
    func logWith(_ level: LogLevel, message: String) {
        print("\(level.name()): \(message)")
    }
}
