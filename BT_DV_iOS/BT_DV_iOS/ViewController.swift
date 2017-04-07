//
//  ViewController.swift
//  BT_DV_iOS
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var thumbnail: UIButton!
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var frontCamera: Bool = false
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation

 //存入相簿
    func savePhotoToLibrary(_ image: UIImage) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success: Bool, error: Error?) -> Void in
            if success {
                // Set thumbnail
                self.setPhotoThumbnail(image)
            } else {
                print("Error writing to photo library: \(error!.localizedDescription)")
            }
        }
    }
    
    func setPhotoThumbnail(_ image: UIImage) {
        DispatchQueue.main.async { () -> Void in
            self.thumbnail.setBackgroundImage(image, for: UIControlState())
            self.thumbnail.layer.borderColor = UIColor.white.cgColor
            self.thumbnail.layer.borderWidth = 1.0
        }
    }
    
    
    //偵測畫面旋轉
    func rotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeRight
            print("landscape")
        case .landscapeRight:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
        default:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portrait
            
            print("Portrait")
        }
    }

    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        
        layer.videoOrientation = orientation
        
        previewLayer?.frame = self.view.bounds
        
    }
    
    
    @IBAction func capturePicture(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            //測試中的照片旋轉
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, eror) in
                let imageDate = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                let image = UIImage(data: imageDate!)
                
                print("take image: \(image)")
                self.savePhotoToLibrary(image!)
                  self.rotated()
                
            })
        }

    }
    
    
    @IBAction func setCamera(_ sender: Any) {
        frontCamera = !frontCamera
        print(!frontCamera)
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput: AVCaptureInput in inputs{
            captureSession.removeInput(oldInput)
        }
        frontCamera(frontCamera)
        captureSession.commitConfiguration()

    }
    
    @IBAction func setFlash(_ sender: Any) {
        if captureDevice!.hasTorch{
            do{
                try captureDevice!.lockForConfiguration()
                captureDevice!.torchMode = captureDevice!.isTorchActive ? AVCaptureTorchMode.off :AVCaptureTorchMode.on
                
                captureDevice!.unlockForConfiguration()
                
            }catch{
                
            }
        }

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.previewLayer?.connection  {
            
            let currentDevice: UIDevice = UIDevice.current
            
            let orientation: UIDeviceOrientation = currentDevice.orientation
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
                
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
                    break
                    
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
                    break
                    
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                
                    break
                    
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                }
            }
        }
    }

    func beginSession(){
        print("有沒有在這裡耶")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        captureSession.startRunning() //啟動captureSession 太白癡居然卡在這邊
        //set up output Image format
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput){
            captureSession.addOutput(stillImageOutput)
        }
        
    }
    
    //前置相機
    func frontCamera(_ front: Bool){
        let devices = AVCaptureDevice.devices()
        do{
            
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
            
        }catch{
            print("error",error.localizedDescription)
            
        }
        
        
        
        for device in devices!{
            
            if((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if front{
                    if (device as AnyObject).position == AVCaptureDevicePosition.front{
                        captureDevice = device as? AVCaptureDevice
                        print("我猜沒來這邊")
                        do{
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch{
                            
                        }
                        break
                    }
                }else{
                    if (device as AnyObject).position == AVCaptureDevicePosition.back{
                        captureDevice = device as? AVCaptureDevice
                        do{
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch{
                            
                        }
                        break
                    }
                }
                
                
            }
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        frontCamera(frontCamera)
        
        if captureDevice != nil{
            beginSession()
            
        }
        
        //去觀察畫面是否轉向
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

