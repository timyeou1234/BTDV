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
        let BLEprotocol = FuelProtocol()
        let bleProtoclol = BLEprotocol.getInstanceSimulation(false, printLog: true) as! FuelProtocol
        BLEObject.BLEobj.ble = bleProtoclol
        
        NotificationCenter.default.post(name: NSNotification.Name("FailConnect"), object: BLEObject.BLEobj)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
