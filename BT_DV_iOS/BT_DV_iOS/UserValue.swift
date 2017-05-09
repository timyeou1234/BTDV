//
//  UserValue.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/9.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class UserValue: NSObject {
    static let user = UserValue()
    
    var tapToTakePhoto:Bool?
    var window: UIWindow?
    var valueGetFromFlash = "btn_flash_auto_1"
    var indexPath:IndexPath?
    var valueFromFlash:IndexPath?
    var valueFromWhiteBalance:IndexPath?
    var valueFromEV:Int?
    var valueFromSize:IndexPath?
    
    var bleUUID:[String] = []
    var bleName:[String] = []
    var bleRssi:[Int32] = []
    
    var batteryInfo:Int32?
    var hwInfo:String?
    var softInfo:String?
    var BLEprotocol = FuelProtocol()
    
}
