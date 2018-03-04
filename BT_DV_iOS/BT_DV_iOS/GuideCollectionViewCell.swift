//
//  GuideCollectionViewCell.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2018/1/17.
//  Copyright © 2018年 VictorBasic. All rights reserved.
//

import UIKit

class GuideCollectionViewCell: UICollectionViewCell {

    var index = 0
    
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var pageIndexImage: UIImageView!
    @IBOutlet weak var startUsingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIndex(_ index:Int, orientation: UIDeviceOrientation){
        var image = UIImage()
        let indexName = "btn_guide_page_0\(index + 1)"
        pageIndexImage.image = UIImage(named: indexName)
        switch index {
        case 0:
            if orientation == UIDeviceOrientation.portrait{
                image = UIImage.gifImageWithName("img_guide_01")!
            }else{
                image = UIImage.gifImageWithName("img_guide_horizontal_01")!
            }
        case 1:
            if orientation == UIDeviceOrientation.portrait{
                image = UIImage.gifImageWithName("img_guide_02")!
            }else{
                image = UIImage.gifImageWithName("img_guide_horizontal_02")!
            }
        default:
            if orientation == UIDeviceOrientation.portrait{
                image = UIImage(named: "img_guide_0\(index + 1)")!
            }else {
                image = UIImage(named: "img_guide_horizontal_0\(index + 1) 拷貝")!
            }
//            if orientation == UIDeviceOrientation.landscapeRight{
//                image = UIImage(named: "img_guide_horizontal_0\(index + 1)")!
//            }else{
//                image = UIImage(named: "img_guide_horizontal_0\(index + 1) 拷貝")!
//            }
        }
        
        startUsingButton.isHidden = index != 6
        
        guideImage.image = image
        
    }

}
