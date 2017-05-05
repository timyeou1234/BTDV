//
//  Bleprotoc.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class Bleprotoc: NSObject {
    
    static let BLE = Bleprotoc()
    var shardBleprotocol:FuelProtocol?
    private override init() {
    
    }
 
//    func getInstance()-> FuelProtocol{
//        if(self.shardBleprotocol == nil){
//            self.shardBleprotocol?.getInstanceSimulation(false, printLog: false)
//        
//        }
//        return self.shardBleprotocol!
//    }

}

/*
 import UIKit
 
 class DataAccessObject: NSObject {
 
 static let sharedInstance = DataAccessObject()
 
 private override init() {
 print("init...")
 }
 
 deinit {
 print("deinit...")
 }
 
 func loadDatas() {
 print("loadDatas...")
 }
 }

 */
