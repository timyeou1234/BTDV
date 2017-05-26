//
//  FailToConnectViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class FailToConnectViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BLEObject.BLEobj.batteryInfo = nil
        BLEObject.BLEobj.bleDetail = nil
        BLEObject.BLEobj.command = nil
        BLEObject.BLEobj.state = nil
        let bleProtoclol = FuelProtocol()
        BLEObject.BLEobj.ble = bleProtoclol
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            NotificationCenter.default.post(name: NSNotification.Name("FailConnect"), object: BLEObject.BLEobj)
        }
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
