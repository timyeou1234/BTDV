//
//  GuideViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2018/1/17.
//  Copyright © 2018年 VictorBasic. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var pageIndex: UIImageView!
    @IBOutlet weak var startUsingButton: UIButton!
    
    @IBAction func gotoAction(_ sender: Any) {
        goMain()
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        if currentIndex < 6 {
            currentIndex += 1
        }
        reloadImage()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        if currentIndex > 0{
            currentIndex -= 1
        }
        reloadImage()
    }
    
    var currentIndex = 0
    @IBOutlet weak var guideImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func reloadImage(){
        if currentIndex == 6{
            startUsingButton.setTitle("開始使用", for: .normal)
        }else{
            startUsingButton.setTitle("略過", for: .normal)
        }
        var image = UIImage()
        let indexName = "btn_guide_page_0\(currentIndex + 1)"
        pageIndex.image = UIImage(named: indexName)
        switch currentIndex {
        case 0:
            if UIDevice.current.orientation == UIDeviceOrientation.portrait{
                image = UIImage.gifImageWithName("img_guide_01")!
            }else{
                image = UIImage.gifImageWithName("img_guide_horizontal_01")!
            }
        case 1:
            if UIDevice.current.orientation == UIDeviceOrientation.portrait{
                image = UIImage.gifImageWithName("img_guide_02")!
            }else{
                image = UIImage.gifImageWithName("img_guide_horizontal_02")!
            }
        default:
            if UIDevice.current.orientation == UIDeviceOrientation.portrait{
                image = UIImage(named: "img_guide_0\(currentIndex + 1)")!
            }else {
                image = UIImage(named: "img_guide_horizontal_0\(currentIndex + 1)")!
            }
            
        }
        guideImage.image = image
    }
    
    func rotated() {
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefault = UserDefaults.standard
        if let _ = userDefault.string(forKey: "isFirst"){
            
        }else{
            userDefault.set("First", forKey: "isFirst")
        }
        reloadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        reloadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GuideCollectionViewCell
        
        cell.setIndex(indexPath.item, orientation: UIDevice.current.orientation)
        cell.startUsingButton.addTarget(self, action: #selector(self.goMain), for: .touchUpInside)
        return cell
    }
    
    @objc func goMain(){
        self.performSegue(withIdentifier: "goMainSegue", sender: nil)
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
