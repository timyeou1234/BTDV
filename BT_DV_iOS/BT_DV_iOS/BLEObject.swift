//
//  BLEObject.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/12.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class BLEObject: NSObject {
    static let BLEobj = BLEObject()
    var ble:FuelProtocol?
    var state:Bool?
    var bleDetail:BLEDetail?
    var manager:BtManager?
    var batteryInfo:Int32?
    var command:Int32?
}

class BLEDetail:NSObject{
    var bleUUID:String?
    var bleName:String?
    var bleRssi:Int32?
}
