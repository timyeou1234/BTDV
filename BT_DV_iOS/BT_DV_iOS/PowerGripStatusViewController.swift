//
//  PowerGripStatusViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class PowerGripStatusViewController: UIViewController {

    @IBOutlet weak var softVersionLabel: UILabel!
    @IBOutlet weak var powerGripNameLabel: UILabel!
    @IBOutlet weak var hwVersion: UILabel!
    
    var hwVersionValue : String!
    var softVersionValue :String!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()

    }
    
    
    
    
    /*
     let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
     DispatchQueue.main.asyncAfter(deadline: when) {
     self.willMove(toParentViewController: nil)
     self.view.removeFromSuperview()
     self.removeFromParentViewController()
     }

 */
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let appl = UIApplication.shared.delegate as! AppDelegate

        softVersionLabel.text = appl.softInfo
        powerGripNameLabel.text = String(describing: appl.bleName)
        hwVersion.text = appl.hwInfo
        print("硬體值",hwVersionValue)


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
