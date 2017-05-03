//
//  CBlueClass.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import Foundation
import CoreBluetooth

class BtManager : NSObject {
    var mCBCentralManager: CBCentralManager!
    
    override init() {
        super.init();
        initCBCentralManager();
    }
    
    internal func initCBCentralManager() {
        mCBCentralManager = CBCentralManager(delegate: self, queue: nil,
                                             options:[CBCentralManagerOptionShowPowerAlertKey: true]);
    }
}

extension BtManager : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)  {
        switch (central.state) {
        case .poweredOn:
            print("state On");
        case .poweredOff:
            print("state Off");
        case .unknown:
            fallthrough;
        default:
            print("state Unknow");
        }
    }
    
}
