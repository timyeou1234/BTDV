//
//  AppDelegate.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isFromUpdate:Bool?
    var tapToTakePhoto:Bool?
    var window: UIWindow?
    var valueGetFromFlash = "btn_flash_auto_1"
    var indexPath:IndexPath?
    var valueFromFlash:IndexPath?
    //設定頁中白平衡選擇值
    var valueFromWhiteBalance:IndexPath?
    var valueFromEV:Int?
    var valueFromSize:IndexPath?
    //設定頁中場景選擇值
    var valueFromScene:IndexPath?

    var batteryInfo:Int32?
    var hwInfo:String?
    var softInfo:String?
    var BLEprotocol = FuelProtocol()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isIdleTimerDisabled = false
        // Override point for customization after application launch.

        let userDefault = UserDefaults.standard
        if let _ = userDefault.string(forKey: "isFirst"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        let presentedViewController = UIHelper.topViewController()
        if presentedViewController is GuideViewController{
            return .allButUpsideDown
        }
        
        
        // Only allow portrait (standard behaviour)
        return .portrait;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: NSNotification.Name("postFlash"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

class UIHelper{
    /**This method returns top view controller in application  */
    class func topViewController() -> UIViewController?
    {
        let helper = UIHelper()
        return helper.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    /**This is a recursive method to select the top View Controller in a app, either with TabBarController or not */
    private func topViewControllerWithRootViewController(rootViewController:UIViewController?) -> UIViewController?
    {
        if(rootViewController != nil)
        {
            // UITabBarController
            if let tabBarController = rootViewController as? UITabBarController,
                let selectedViewController = tabBarController.selectedViewController {
                return self.topViewControllerWithRootViewController(rootViewController: selectedViewController)
            }
            
            // UINavigationController
            if let navigationController = rootViewController as? UINavigationController ,let visibleViewController = navigationController.visibleViewController {
                return self.topViewControllerWithRootViewController(rootViewController: visibleViewController)
            }
            
            if ((rootViewController!.presentedViewController) != nil) {
                let presentedViewController = rootViewController!.presentedViewController;
                return self.topViewControllerWithRootViewController(rootViewController: presentedViewController!);
            }else
            {
                return rootViewController
            }
        }
        
        return nil
    }
}
