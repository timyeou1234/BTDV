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

let CaptureModePhoto = 0
let CaptureModeMovie = 1




class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var thumbnail: UIButton!
    
    @IBOutlet weak var photoOrMovieBtn: UIButton!
    
    @IBOutlet weak var captureBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var setCameraBtn: UIButton!
    
    @IBOutlet weak var setFlashBtn: UIButton!
    
    @IBOutlet var setSenceBtn: SettinSenceButton!
    
    
    @IBOutlet weak var batteryStatus: UIImageView!
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var frontCamera: Bool = false
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    let movieOutput = AVCaptureMovieFileOutput()
    var activeInput: AVCaptureDeviceInput!

    
    var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    
    
    var format = AVCaptureDeviceFormat()
    
    var counter = 0
    
    var videoCounter = 0
    //設定錄影或拍照用
    var captureMode: Int = CaptureModePhoto
    
    var outputURL: URL!
    
    //faceDetect
    var faceRectCALayer: CALayer!
    fileprivate var sessionQueue: DispatchQueue = DispatchQueue(label: "videoQueue", attributes: [])
    
    var deviceIsChange: Bool = false
    

    
    @IBAction func capturePhotoOrMovie(_ sender: Any) {
        if captureMode == CaptureModePhoto {
            capturePhoto()
            print("看來真的在這邊唷")
        } else {
            captureMovie()
            print("看來不在這邊唷")
        }
    }
    
    @IBAction func setPhotoOrMovie(_ sender: Any) {
        if videoCounter % 2 == 0{
            captureMode = CaptureModeMovie
            videoCounter += 1
            let image = UIImage(named: "btn_video")
            photoOrMovieBtn.setImage(image, for: UIControlState.normal)
            print("Video")
        }else{
            let image = UIImage(named: "btn_camera")
            captureMode = CaptureModePhoto
            
            videoCounter += 1
            photoOrMovieBtn.setImage(image, for: UIControlState.normal)

            print("Photo")
            
        }
        

    }
    
    
    @IBAction func tumbnailOpenLibrary(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
      //  imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func setCamera(_ sender: Any) {
        // Make sure the device has more than 1 camera.
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 1 {
            // Check which position the active camera is.
            var newPosition: AVCaptureDevicePosition!
            if activeInput.device.position == AVCaptureDevicePosition.back {
                newPosition = AVCaptureDevicePosition.front
                setlayerHidden(true)
                
                deviceIsChange = true
            } else {
                newPosition = AVCaptureDevicePosition.back
                deviceIsChange = true
                setlayerHidden(true)
                
            }
            
            // Get camera at new position.
            var newCamera: AVCaptureDevice!
            let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in devices! {
                if (device as AnyObject).position == newPosition {
                    newCamera = device as! AVCaptureDevice
                }
            }
            
            // Create new input and update capture session.
            do {
                let input = try AVCaptureDeviceInput(device: newCamera)
                captureSession.beginConfiguration()
                // Remove input for active camera.
                captureSession.removeInput(activeInput)
                // Add input for new camera.
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                } else {
                    captureSession.addInput(activeInput)
                }
                captureSession.commitConfiguration()
                //這邊之後給上方標籤
                //                flashLabel.text = currentFlashOrTorchMode().name
            } catch {
                print("Error switching cameras: \(error)")
            }
        }

    }
    
    @IBAction func setFlash(_ sender: Any) {
//        if captureDevice!.hasTorch{
//            do{
//                try captureDevice!.lockForConfiguration()
//                captureDevice!.torchMode = captureDevice!.isTorchActive ? AVCaptureTorchMode.off :AVCaptureTorchMode.on
//                
//                captureDevice!.unlockForConfiguration()
//                
//            }catch{
//                
//            }
//        }

    }
    @IBAction func setSence(_ sender: Any) {
/*
          let sence = setSenceBtn?.initMenu(["Item A", "Item B", "Item C"], actions: [({ () -> (Void) in
                self.setting()
            }), ({ () -> (Void) in
                print("QQ")
            }), ({ () -> (Void) in
                print("Estou fazendo a ação C")
            })])

       
*/
    }
    
//MARK:- CapturePhoto
    func capturePhoto(){
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, eror) in
                let imageDate = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                let image = UIImage(data: imageDate!)
                
                print("take image: \(image)")
                self.savePhotoToLibrary(image!)
                self.rotated()
                
                //底下的小縮圖
                self.cameraView.backgroundColor = UIColor(patternImage: image!)
//                self.imageThundernil.image = image
            })
        }
        
        
    }

    
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
    
    //NO NEED
    
    func beginSession(){
        print("有沒有在這裡耶")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        captureSession.startRunning() //啟動captureSession
        //set up output Image format
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput){
            captureSession.addOutput(stillImageOutput)
        }
        
    }
    
    //MARK: CaptureVideo
    func captureMovie() {
        if movieOutput.isRecording == false {
  
            captureBtn.setImage(UIImage(named: "btn_stop"), for: UIControlState())
            
            topView.isHidden = true
            let connection = movieOutput.connection(withMediaType: AVMediaTypeVideo)
            
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
                print(Error.self)
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if (device?.isSmoothAutoFocusSupported)! {
                do {
                    try device?.lockForConfiguration()
                    device?.isSmoothAutoFocusEnabled = false
                    device?.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            outputURL = tempURL()
            movieOutput.startRecording(toOutputFileURL: outputURL, recordingDelegate: self)
        } else {
            stopRecording()
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording == true {
            captureBtn.setImage(UIImage(named: "btn_start"), for: UIControlState())
            topView.isHidden = false
            movieOutput.stopRecording()
        }
    }
    
    func saveMovieToLibrary(_ movieURL: URL) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieURL)
        }) { (success: Bool, error: Error?) -> Void in
            if success {
                // Set thumbnail
                self.setVideoThumbnailFromURL(movieURL)
            } else {
                print("Error writing to movie library: \(error!.localizedDescription)")
            }
        }
    }
    
    func setVideoThumbnailFromURL(_ movieURL: URL) {
        videoQueue().async { () -> Void in
            let asset = AVAsset(url: movieURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.maximumSize = CGSize(width: 100.0, height: 0.0)
            imageGenerator.appliesPreferredTrackTransform = true
            var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
            
            var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
            
            do {
                let imageRef = try imageGenerator.copyCGImage(at: kCMTimeZero,
                                                              actualTime: nil)
                let image = UIImage(cgImage: imageRef)
                self.setPhotoThumbnail(image)
            } catch {
                print("Error generating image: \(error)")
            }
        }
    }
    
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent("penCam.mov")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }

    //MARK:-BeginSession
    
    //設定Session
    func setupSession() -> Bool {
        

        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // Setup Camera
        let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        //Setup faceDetect
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        }
        
        
        
        // Setup Microphone
        let microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        
        // Still image output
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    
    func setPreview(){
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
    }
    
    //ADD layer to custom view. 重新調整後這個沒有用了  ？？確認設定前後鏡頭的func
/*
    func beginSession() {
        print("有沒有在這裡耶")
        captureSession.startRunning() //啟動captureSession 太白癡居然卡在這邊
        //set up output Image format
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG] //這段程式碼在更新後放在serSession裡頭
        if captureSession.canAddOutput(stillImageOutput){
            captureSession.addOutput(stillImageOutput)
        }
        
    }
 */
    func startSession() {
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    }

//MARK:-SettingFlashAndTourch
    
    func currentFlashOrTorchMode() -> (mode: Int, name: String) {
        var currentMode: Int = 0
        if captureMode == CaptureModePhoto {
            currentMode = activeInput.device.flashMode.rawValue
        } else {
            currentMode = activeInput.device.torchMode.rawValue
        }
        var modeName: String!
        
        switch currentMode {
        case 0:
            modeName = "Off"
        case 1:
            modeName = "On"
        case 2:
            modeName = "Auto"
            
        default:
            modeName = "Off"
        }
        
        if !activeInput.device.hasFlash {
            modeName = "N/A"
        }
        
        return (currentMode, modeName)
    }
    
    //flashMode
    func setFlashMode() {
        let device = activeInput.device
        if (device?.hasFlash)! {
            var currentMode = currentFlashOrTorchMode().mode
            currentMode += 1
            if currentMode > 2 {
                currentMode = 0
                print("currentMode",currentMode)
            }
            
            let newMode = AVCaptureFlashMode(rawValue: currentMode)!
            
            if (device?.isFlashModeSupported(newMode))! {
                do {
                    try device?.lockForConfiguration()
                    device?.flashMode = newMode
                    device?.unlockForConfiguration()
                    //                    flashLabel.text = currentFlashOrTorchMode().name
                } catch {
                    print("Error setting flash mode: \(error)")
                }
            }
        }
    }
    
    //TorchMODE
    func setTorchMode() {
        let device = activeInput.device
        if (device?.hasTorch)! {
            var currentMode = currentFlashOrTorchMode().mode
            currentMode += 1
            if currentMode > 2 {
                currentMode = 0
                
            }
            
            let newMode = AVCaptureTorchMode(rawValue: currentMode)!
            
            if (device?.isTorchModeSupported(newMode))! {
                do {
                    try device?.lockForConfiguration()
                    device?.torchMode = newMode
                    device?.unlockForConfiguration()
                    //                    flashLabel.text = currentFlashOrTorchMode().name
                } catch {
                    print("Error setting torch mode: \(error)")
                }
            }
        }
    }
//MARK:-FaceDetect
    
    func setupFace(){
        print("人臉偵測耶，拜託快來")
        faceRectCALayer = CALayer()
        faceRectCALayer.zPosition = 1
        faceRectCALayer.borderColor = UIColor.green.cgColor
        faceRectCALayer.borderWidth = 3.0
        
        previewLayer?.addSublayer(faceRectCALayer)
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var faces = [CGRect]()
        
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                let transformedMetadataObject = previewLayer?.transformedMetadataObject(for: metadataObject)
                let face = transformedMetadataObject?.bounds
                faces.append(face!)
            }
        }
        
        print("FACE",faces)
        
        if faces.count > 0 {
            setlayerHidden(false)
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.faceRectCALayer.frame = self.findMaxFaceRect(faces)
            })
        } else {
            setlayerHidden(true)
        }
    }
    
    func setlayerHidden(_ hidden: Bool) {
        if (faceRectCALayer.isHidden != hidden) && deviceIsChange{
            print("o o o oo  o oo o ",deviceIsChange)
            print("hidden:" ,hidden)
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.faceRectCALayer.isHidden = hidden
            })
        }
    }
    
    func findMaxFaceRect(_ faces : Array<CGRect>) -> CGRect {
        if (faces.count == 1) {
            return faces[0]
        }
        var maxFace = CGRect.zero
        var maxFace_size = maxFace.size.width + maxFace.size.height
        for face in faces {
            let face_size = face.size.width + face.size.height
            if (face_size > maxFace_size) {
                maxFace = face
                maxFace_size = face_size
            }
        }
        return maxFace
        
    }
    
    
    
    //MARK:-ZoomInOut
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = activeInput.device else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
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
    
    
    //MARK: ISO_Shutter Setting
    
    func seting2 (){
        try! captureDevice?.lockForConfiguration()
        captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 320), iso: 200, completionHandler: nil)
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 5000,tint: 15)
        self.setWhiteBalanceGains(self.captureDevice!.deviceWhiteBalanceGains(for: temperatureAndTint))
        captureDevice?.unlockForConfiguration()
        
        
    }
    func setting (){
        try! captureDevice?.lockForConfiguration()
        /*
         if (captureDevice?.isExposureModeSupported(.continuousAutoExposure))!{
         captureDevice?.exposurePointOfInterest = CGPoint(x: 0.5, y: 0.5)
         captureDevice?.exposureMode = .continuousAutoExposure
         
         }
         */
        
        //設定快門1/30分之一秒  iso 50
        //        print((captureDevice?.activeFormat.maxISO)!)
do{
//        captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 500), iso: 200, completionHandler: nil)
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 3000,tint: 15)
        self.setWhiteBalanceGains(self.captureDevice!.deviceWhiteBalanceGains(for: temperatureAndTint))
        captureDevice?.unlockForConfiguration()
        }catch{
print("ERRRRRROR")
}
        /*
         if ((captureDevice?.lockForConfiguration) != nil){
         let maxISO = captureDevice?.activeFormat.maxISO
         let minISO = captureDevice?.activeFormat.minISO
         let newISO = maxISO! - minISO!
         captureDevice?.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, iso: newISO, completionHandler: nil)
         captureDevice?.unlockForConfiguration()
         print("iso 100")
         }
         */
    }
    //設定白平衡增益
    private func setWhiteBalanceGains(_ gains: AVCaptureWhiteBalanceGains) {
        
        do {
            try self.captureDevice!.lockForConfiguration()
            let normalizedGains = self.normalizedGains(gains) // Conversion can yield out-of-bound values, cap to limits
            self.captureDevice!.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(normalizedGains, completionHandler: nil)
            self.captureDevice!.unlockForConfiguration()
        } catch let error {
            NSLog("Could not lock device for configuration: \(error)")
        }
    }
    
    // 初始化增益值
    private func normalizedGains(_ gains: AVCaptureWhiteBalanceGains) -> AVCaptureWhiteBalanceGains {
        var g = gains
        
        g.redGain = max(1.0, g.redGain)
        g.greenGain = max(1.0, g.greenGain)
        g.blueGain = max(1.0, g.blueGain)
        
        g.redGain = min(self.captureDevice!.maxWhiteBalanceGain, g.redGain)
        g.greenGain = min(self.captureDevice!.maxWhiteBalanceGain, g.greenGain)
        g.blueGain = min(self.captureDevice!.maxWhiteBalanceGain, g.blueGain)
        
        return g
    }


    
    //偵測畫面旋轉
    func rotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeRight
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.batteryStatus.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))



            print("landscape")
        case .landscapeRight:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.batteryStatus.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

            
            
        case .portraitUpsideDown:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.batteryStatus.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))


            print("上下顛倒啦")
            
            
        default:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portrait
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.batteryStatus.transform = CGAffineTransform(rotationAngle: CGFloat(0))

            
            
            print("Portrait")
        }
    }
    
    
    
//MARK:- Rotated
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        
        layer.videoOrientation = orientation
        
        previewLayer?.frame = self.view.bounds
        
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
                    
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                print("右邊橫躺")
                
                    break
                    
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                }
            }
        }
    }

    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setting()
    }
    override func viewWillLayoutSubviews() {
        
            }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinch(_:)))
        
        
        self.view.addGestureRecognizer(pinchGesture)
        
        


        if setupSession(){

            setPreview()
            setupFace()
            startSession()
            
            
        }

 
      
 

        
        //去觀察畫面是否轉向
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
/*
    
    override func viewDidAppear(_ animated: Bool) {
        setSenceBtn?.initMenu(["Item A", "Item B", "Item C"], actions: [({ () -> (Void) in
            self.setting()
        }), ({ () -> (Void) in
            print("QQ")
        }), ({ () -> (Void) in
            print("Estou fazendo a ação C")
        })])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

*/
}

extension ViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            // Write video to library
            saveMovieToLibrary((outputURL as? URL)!)
        }
        outputURL = nil
    }
    
}

