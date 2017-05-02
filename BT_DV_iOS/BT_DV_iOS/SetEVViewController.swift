//
//  SetEVViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class SetEVViewController: UIViewController {
    



    @IBOutlet weak var sliderForEV: UISlider!
    
    @IBOutlet weak var evlabel: UILabel!
    @IBAction func changeExposureTargetBias(_ control: UISlider) {
        
        evlabel.text = String(Int(floor(sliderForEV.value)))
        let appl = UIApplication.shared.delegate as! AppDelegate
        appl.valueFromEV = Int(floor(sliderForEV.value))
        //透過notification傳值給ViewController
        NotificationCenter.default.post(name: NSNotification.Name("postEV"), object: Int(floor(sliderForEV.value)))
        
    }

    
    @IBAction func backAndSendData(_ sender: Any) {
        //移除自己並傳值
        performSegue(withIdentifier: "unwindFromEV", sender: Any?.self)
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromEV"{
            
                if let vc = segue.destination as? settingViewController{
                    vc.evValue = String(Int(floor(sliderForEV.value)))
                    print("EEEEVVVVV",String(Int(floor(sliderForEV.value))))
                    vc.settingTableView.reloadData()
                }
            
        }

    }


}
