//
//  UpdateFailViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/16.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class UpdateFailViewController: UIViewController {

    @IBAction func comfirmAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("updateComplete"), object: BLEObject.BLEobj)
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
