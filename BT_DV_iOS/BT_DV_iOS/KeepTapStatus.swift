//
//  KeepTapStatus.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import Foundation
import UIKit

open class keepTapStatus: NSObject {
    
    
    
    
    var name: String!
    var address: String!
    var isInvited: Bool!
    var profilePic: UIImage!
    
    init(name: String, address: String, isInvited: Bool, profilePic: UIImage!) {
        self.name = name
        self.address = address
        self.isInvited = isInvited
        self.profilePic = profilePic ?? nil
    }
/*
    var name: String!
    var isTap: Bool!
    
    init( name:String, isTap: Bool) {
        self.name = name
        self.isTap = isTap
    }
 */
}
