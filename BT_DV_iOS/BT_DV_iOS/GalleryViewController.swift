//
//  GalleryViewController.swift
//  BT_DV_iOS
//
//  Created by YeouTimothy on 2017/5/17.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer
import MobileCoreServices
import AVKit
import AVFoundation

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var isFirst = true
    
    var imageUrl:NSURL?
    var videoUrl:NSURL?
    var videoAssetUrl:NSURL?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBAction func playAction(_ sender: Any) {
        let playerController = AVPlayerViewController()
        let avPlayer = AVPlayer(url: videoUrl! as URL)
        playerController.player = avPlayer
        self.present(playerController, animated: true, completion: {
            playerController.player?.play()
        })
    }
    
    @IBAction func retunrAction(_ sender: Any) {
        openLibrary()
    }
    
    @IBAction func deleteImageOrVideo(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges( {
            if let imageUrl = self.imageUrl{
                let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: [imageUrl as URL], options: nil)
                PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
            }else{
                if let videoUrl = self.videoAssetUrl{
                    let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: [videoUrl as URL], options: nil)
                    PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
                }
            }
        },completionHandler: { success, error in
                                                    self.openLibrary()
        }
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isFirst{
            isFirst = false
            openLibrary()
        }
    }
    
    func openLibrary(){
        imageUrl = nil
        videoUrl = nil
        videoAssetUrl = nil
        photoImage.image = nil
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        pop()
    }
    
    func pop(){
        self.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            playButton.isHidden = true
            photoImage.image = image
            if let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL{
                self.imageUrl = imageUrl
            }
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        if let video = info[UIImagePickerControllerMediaURL] as? NSURL{
            self.videoAssetUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
            picker.dismiss(animated: true, completion: nil)
            self.videoUrl = video
            playButton.isHidden = false
            photoImage.image = setVideoThumbnailFromURL(video as URL)
        }
    }
    
    func setVideoThumbnailFromURL(_ movieURL: URL) -> UIImage? {
        
        let asset = AVAsset(url: movieURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        //        imageGenerator.maximumSize = CGSize(width: 100.0, height: 0.0)
        imageGenerator.appliesPreferredTrackTransform = true
        var _: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
        
        var _: UIDeviceOrientation = UIDevice.current.orientation
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: kCMTimeZero,
                                                          actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch {
            print("Error generating image: \(error)")
        }
        return nil
    }
    
    
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
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
