//
//  updateFirmwareViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/16.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

class updateFirmwareViewController: UIViewController {
    
    @IBOutlet weak var comfirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func comfirmAction(_ sender: Any) {
        (sender as! UIButton).backgroundColor = UIColor.green
        NotificationCenter.default.post(name: NSNotification.Name("beginUpdate"), object: BLEObject.BLEobj)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrepareUpdateViewController")
        self.addChildViewController(vc!)
        vc?.didMove(toParentViewController: self)
        vc?.view.frame = self.view.frame
        self.view.addSubview((vc?.view)!)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        (sender as! UIButton).backgroundColor = UIColor.green
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateComplete"), object:nil, queue: nil) { notification in
            self.willMove(toParentViewController: self)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        comfirmButton.backgroundColor = UIColor.white
        cancelButton.backgroundColor = UIColor.white
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

class BackgroundHighlightedButton: UIButton {
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
            super.isHighlighted = newValue
        }
    }
}

