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



class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,ConnectStateDelegate {
    /**
     * 開啟設備BLE事件
     * @param isEnable 藍牙是否開啟
     */
    var blueDataArray = [String(),String(),Int32()] as [Any]

    func onConnectionState(_ state: ConnectState) {
        print("onConnectionState-----state = \(state)")
        if state == ScanFinish {
            print("connection status Connected")
        }
        else if state == Disconnect {
            print("connection status Disconnected")
        }
        
    }

 
    func onBtStateChanged(_ isEnable: Bool) {
        if isEnable == false{
        print("ＯＰＥＮＢＬＥ")
        
        }else {
        
        print("ALREADYHere")
        }
//        onConnectionState(ConnectState.init(2))
//        if isEnable == false{
//        
//        }else{
//            BLEProtocol?.connectUUID("Power Grip")
//            print("安安")
//        }
    }

  
//    var isConnect:Bool?
//    var BLEProtocol: FuelProtocol?
    /**
     * 返回掃描到的藍牙
     * @param uuid mac address
     * @param name 名稱
     * @param rssi 訊號強度
     */

    
 
    func onScanResultUUID(_ uuid: String!, name: String!, rssi: Int32) {
        print("藍芽",uuid,name,rssi)
    
    }
 

    /**
     * 開啟設備BLE事件
     * @param isEnable 藍牙是否開啟
     */
    

//    protocol DataResponseDelegate: class {
//        //KeyCode:4(Zoom in)
//        //KeyCode:1(Zoom out)
//        //KeyCode:2(拍照/錄影)
//        func onResponsePressed(_ keyboardCode: Int)
//    }
//    //測試用---
//    protocol ProtocolTestDelegate: class {
//        func onWriteCommand(_ command: String)
//        
//        func onNotifyCommand(_ command: String)
//    }
    
 /*
    self.manager.loadLastImageThumb { [weak self] (image) in
    DispatchQueue.main.async {
    self?.galleryButton.setImage(image, for: .normal)
    }
    }
 */

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var thumbnail: UIButton!
    
    @IBOutlet weak var photoOrMovieBtn: UIButton!
    
    @IBOutlet weak var captureBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var setCameraBtn: UIButton!
    
    @IBOutlet weak var setFlashBtn: UIButton!
    
    @IBOutlet var setSenceBtn: UIButton!
    
    
//    @IBOutlet weak var batteryStatus: UIImageView!
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var frontCamera: Bool = false
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    let movieOutput = AVCaptureMovieFileOutput()
    var activeInput: AVCaptureDeviceInput!

    
    var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    
    
    var format = AVCaptureDeviceFormat()
//    MARK:-FORTOP
    var counter = 0
    var counterForFlashLight = 0
    var counterForSetting = 0
    var videoCounter = 0
    //待驗證
    var tapOrNot = false
    var flashToMain = "btn_flash_auto_1"
    var beSelect = Bool()
    
    //設定錄影或拍照用
    var captureMode: Int = CaptureModePhoto
    
    var outputURL: URL!
    
    //faceDetect
    var faceRectCALayer: CALayer!
    fileprivate var sessionQueue: DispatchQueue = DispatchQueue(label: "videoQueue", attributes: [])
    
    var deviceIsChange: Bool = false
    
    
    //MARK:-BLE
    var BLEprotocol = FuelProtocol()


//
//    func onBtStateChanged(_ isEnable: Bool) {
//        if isEnable == true{
//            BLEProtocol.
//            print("有沒有準備來藍牙這邊")
//            if BLEProtocol?.connectUUID("Power Grip"){
//            print("有連到唷")
//            }else{
//            
//            }
//            func onScanResultUUID(_ uuid: String, name: String, rssi: Int32) {
//                let id = uuid
//                let n = name
//                let rs = rssi
//                print("藍牙狀態",(id,n,rs))
//                
//            }
//
////            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartScanBLEViewController") as! StartScanBLEViewController
////            self.addChildViewController(popOverVC)
////            popOverVC.view.frame = self.view.frame
////            self.view.addSubview(popOverVC.view)
////            popOverVC.didMove(toParentViewController: self)
//            
//            
//            print("成功連線")
//            isConnect = isEnable
//            
//            
//        }else{
//            print("oo")
//            
//        }
//    }
//    

//    func onScanResultUUID(_ uuid: String, name: String, rssi: Int32) {
//        
//
//        let id = uuid
//        let n = name
//        let rs = rssi
//        print("藍牙狀態",(id,n,rs))
//
//    }
//    func onConnectionState(_ state: ConnectState) {
//        print(state)
//    }
    
    
    
    func toConnect(){
    self.performSegue(withIdentifier: "toConnecting", sender: self)
    }


//MARK:-ContainerView
    @IBOutlet weak var senceTableView: UIView!
    
    @IBOutlet weak var flashLightTableView: UIView!
    
    
    @IBOutlet weak var settingTableView: UIView!
    
    
    @IBOutlet weak var connectAndBatteryTableView: UIView!
    
    
    //逆向傳值用
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    @IBAction func unwindFromFlash(segue:UIStoryboardSegue) { }

//MARK:-Button
    
    @IBAction func capturePhotoOrMovie(_ sender: Any) {
        if captureMode == CaptureModePhoto {
            capturePhoto()
        } else {
            captureMovie()
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
            } catch {
                print("Error switching cameras: \(error)")
            }
        }

    }
    
    @IBAction func setFlash(_ sender: Any) {
        
        if  flashLightTableView.isHidden == true {
        flashLightTableView.isHidden = false
            self.buttopTap()
        }else{
        flashLightTableView.isHidden = true
        }
        
    }
    
    @IBAction func setSence(_ sender: Any) {
        if senceTableView.isHidden == true{
        senceTableView.isHidden = false

        }else{
        senceTableView.isHidden = true
        }
        
        
    }
    
    @IBAction func settingCamera(_ sender: Any) {
        if self.settingTableView.isHidden == true
{
        self.settingTableView.isHidden = false
        }else{
        self.settingTableView.isHidden = true
        }
        
    }
    
    @IBAction func connectBlueTooth(_ sender: Any) {
        
//       let value =  BLEProtocol?.getInstanceSimulation(true, printLog: true)
//        print("藍芽勒",value)
//        
//        func onBtStateEnable(_ isEnable: Bool) {
//            if isEnable == true{
//            print("連接到了")
//            }else{
//            print("沒有·什麼都沒有")
//            }
//        }
//        
//        if BLEProtocol?.onBtStateEnable{
//        print("真的")
//        
//        }else{
//         print("喔喔")
//        }
//        BLEProtocol?.onScanResultUUID(<#T##uuid: String!##String!#>, name: <#T##String!#>, rssi: <#T##Int32#>)
        
//        func onConnectionState(_ state: ConnectState) {
//            print("onConnectionState-----state = \(state)")
//            if state == Connected {
//                print("connection status Connected")
//            }
//            else if state == Disconnect {
//                print("connection status Disconnected")
//            }
//            
//        }

    /*
        func openBluetooth(){
            let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
            let app = UIApplication.shared
            app.openURL(url!)
        }
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
        

   //     captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
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
    
    //MARK:-單點拍攝
    func tapCapture(_ tap: UIPinchGestureRecognizer){
    
        if captureMode == CaptureModePhoto {
            capturePhoto()
        } else {
            captureMovie()
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
    
    func settingAuto(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = AVCaptureExposureMode.autoExpose
            
     //       captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 3), iso: 100, completionHandler: nil)
            device?.unlockForConfiguration()
        }catch{
        }
    }
    
    func settingAction(){
    
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 4000), iso: 400, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    }
    func settingHuman(){
    
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 25), iso: 400, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    }
    
    func settingLandScape(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 100), iso: 100, completionHandler: nil)
            device?.unlockForConfiguration()
            
        }catch{
        }
    }
    
    
    func settingNight(){
    
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            device?.flashMode = .auto
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 25), iso: 500, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
    func settingNightHuman(){
    
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            device?.flashMode = .auto

            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 20), iso: 400, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    }
    
    
    
    func settingThreater(){
        let device = activeInput.device
        do{

        try device!.lockForConfiguration()
        device?.exposureMode = .custom
        device?.flashMode = .auto
        
        captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 800), iso: 500, completionHandler: nil)
        device?.unlockForConfiguration()

            
        }catch{
            
            
        }
        

    }
    
    
    func settingBeach(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 1000), iso: 200, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    }
    
    func settingSnow(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 1500), iso: 50, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }
        

    
    }
    
    func settingSunset(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 2500), iso: 400, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }
        

    }
    func settingNotshaking(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 1500), iso: 300, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
    
    
    func settingFireWork(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 2), iso: 500, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
    func settingSport(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            device?.flashMode = .auto
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 2000), iso: 100, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
    func settingParty(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 800), iso: 500, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
    func settingCandle(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 30), iso: 500, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }

    
    }
    
 //MARK:-SETTINGFlash
    
    
    func setFlashAuto(){
        
        let device = activeInput.device
        if (device?.hasFlash)!{
        do{
            try device?.lockForConfiguration()
            device?.flashMode = .auto
            device?.unlockForConfiguration()
        }catch{
            print("喔")
        }
        }
    }

    
    func setTorchOn(){
        
        let device = activeInput.device
        if (device?.hasFlash)!{

        do{
            try device?.lockForConfiguration()
           if device?.torchMode == .off{
            device?.torchMode = .on
            }else{
            device?.torchMode = .off
            }
            device?.unlockForConfiguration()
        }catch{
            print("喔")
        }
        }
    }
    
    func setFlashOn(){
        let device = activeInput.device
        if (device?.hasFlash)!{

        do{
            try device?.lockForConfiguration()
            device?.flashMode = .on
            device?.unlockForConfiguration()
        }catch{
            print("喔")
        }
        }
    
    }
    
    func setRedEye(){
        let device = activeInput.device
        if (device?.hasFlash)!{

        do{
            try device?.lockForConfiguration()
            device?.flashMode = .on
            device?.unlockForConfiguration()
        }catch{
            print("喔")
        }

        }
    }
    
    func setFlashOff(){
        let device = activeInput.device
        if (device?.hasFlash)!{

        do{
            try device?.lockForConfiguration()
            device?.flashMode = .off
            device?.unlockForConfiguration()
        }catch{
            print("喔")
        }
        }
    }
    
    //MARK:- SETWhiteBalance
    func setWBAuto(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .continuousAutoWhiteBalance
            device?.unlockForConfiguration()
        }catch{
            print("ＮＯＮＯ")
        }
        
//        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 8000,tint: 15)
//        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)
        
        

    }
    
    func setWBDark(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 3500,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    
    }
    func setWBCloudy(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 5000,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    }
    func setWBSunny(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 5500,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    
    }
    func setWBLight(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 6800,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    }
    func setWBYellowLight(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 8000,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    }
    
    func setWBSunset(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 7500,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    }
    
    func setWBWormLight(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
            print("Error")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 9000,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

    }
    func setting4(){
        let device = activeInput.device
        do{
            try device!.lockForConfiguration()
            device?.exposureMode = .custom
            device?.flashMode = .off
            
            captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 2), iso: 500, completionHandler: nil)
            device?.unlockForConfiguration()
            
            
        }catch{
            
            
        }
        
    }

    
    func setting3(){
        let device = activeInput.device
        do{
           try device!.lockForConfiguration()
        device?.whiteBalanceMode = .locked
            device?.unlockForConfiguration()
        }catch{
        print("ＮＯＮＯ")
        }
        
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 8000,tint: 15)
        self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)

        
        }
    
    
    func seting2 (){
        let device = activeInput.device

        do{
        try! device?.lockForConfiguration()
        captureDevice?.setExposureModeCustomWithDuration(CMTime(value:1, timescale: 5), iso: 800, completionHandler: nil)
            
        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: 5000,tint: 15)
 //       self.setWhiteBalanceGains((device?.deviceWhiteBalanceGains(for: temperatureAndTint))!)
        device?.unlockForConfiguration()
        }catch{
        
        print("error")
        }
        
        
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
        let device = activeInput.device
        do {
            try device?.lockForConfiguration()
            let normalizedGains = self.normalizedGains(gains) // Conversion can yield out-of-bound values, cap to limits
            device?.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(normalizedGains, completionHandler: nil)
            device?.unlockForConfiguration()
        } catch let error {
            NSLog("Could not lock device for configuration: \(error)")
        }
    }
    
    // 初始化增益值
    private func normalizedGains(_ gains: AVCaptureWhiteBalanceGains) -> AVCaptureWhiteBalanceGains {
        
        let device = activeInput.device
        var g = gains
        
        g.redGain = max(1.0, g.redGain)
        g.greenGain = max(1.0, g.greenGain)
        g.blueGain = max(1.0, g.blueGain)
        
        g.redGain = min((device?.maxWhiteBalanceGain)!, g.redGain)
        g.greenGain = min((device?.maxWhiteBalanceGain)!, g.greenGain)
        g.blueGain = min((device?.maxWhiteBalanceGain)!, g.blueGain)
        
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
            
            self.senceTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.flashLightTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            self.settingTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))


            print("landscape")
        case .landscapeRight:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
//            self.batteryStatus.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            
            self.senceTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.flashLightTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            self.settingTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

            
            
        case .portraitUpsideDown:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))

            self.senceTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.flashLightTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.settingTableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))



            print("上下顛倒啦")
            
            
        default:
            stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portrait
            self.thumbnail.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.photoOrMovieBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.settingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setCameraBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setFlashBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.setSenceBtn?.transform = CGAffineTransform(rotationAngle: CGFloat(0))

            self.senceTableView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.flashLightTableView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.settingTableView.transform = CGAffineTransform(rotationAngle: CGFloat(0))

            
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

    //MARK:-SET UPPER UI
    
//    func setHighlighted(_ highlighted: Bool) {
//    }
    func buttonClick(_ button: UIButton) {
        // swith
        switch (beSelect){
        case true :
            setSenceBtn.isSelected = !setSenceBtn.isSelected
            beSelect = false

        default:
            setSenceBtn.isSelected = !setSenceBtn.isSelected
            beSelect = true
        }
        print("真假",setSenceBtn.isSelected)
    }
    
    func buttopTap(){
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let image = app.valueGetFromFlash
        self.setFlashBtn.setImage(UIImage(named:(image)), for: UIControlState.normal)
        print(image)
        // print(app.valueGetFromFlash)
        
    }
    
    
    func tapToPhoto(){
    
        
            //tap to capture
            
            let singleFinger = UITapGestureRecognizer(target:self,action: #selector(ViewController.tapCapture(_:)))
            
            // 點幾下才觸發 設置 2 時 則是要點兩下才會觸發 依此類推
            singleFinger.numberOfTapsRequired = 2
            
            
            // 幾根指頭觸發
            singleFinger.numberOfTouchesRequired = 1
            
            // 雙指輕點沒有觸發時 才會檢測此手勢 以免手勢被蓋過
            
            // 為視圖加入監聽手勢
            self.view.addGestureRecognizer(singleFinger)

    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    

 
    override func viewWillLayoutSubviews() {
        
            }
    
    //MAEK:-ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senceTableView.isHidden = true
        self.flashLightTableView.isHidden = true
        self.settingTableView.isHidden = true
        self.connectAndBatteryTableView.isHidden = true
        

//        let name = BLEProtocol?.getBattery()
//        print("電池電量",name)
//        let version  = BLEProtocol?.getFwVersion()
        
        
       BLEprotocol = BLEprotocol.getInstanceSimulation(false, printLog: true) as! FuelProtocol
        
        BLEprotocol.connectStateDelegate = self as! ConnectStateDelegate
 //     BLEprotocol.dataResponseDelegate = self as! DataResponseDelegate
        BLEprotocol.startScanTimeout(1)
//        func startScanTimeout(_ timeout: Int) {
//            let app =  onScanResultUUID(_:String, name: String, rssi: Int)
//            print(app)
//                   }


        func connectUUID(_ uuid: String) {
            if uuid == "Power Grip"{
            print("有連接到唷")
            
            }
        }
        
        func onScanResultUUID(_ uuid: String, name: String, rssi: Int) {
            print("onScanResultUUID-----uuid = \(uuid) , name = \(name) , rssi = \(rssi)")
            if name.contains("Power Grip") {
            }
        }

        
        
        
        

        
        
        let whiteBalanceGains = self.captureDevice?.deviceWhiteBalanceGains ?? AVCaptureWhiteBalanceGains()
        let whiteBalanceTemperatureAndTint = self.captureDevice?.temperatureAndTintValues(forDeviceWhiteBalanceGains: whiteBalanceGains) ?? AVCaptureWhiteBalanceTemperatureAndTintValues()

        print(whiteBalanceGains)
        
        
//self.setSenceBtn.setImage(UIImage(named:"btn_scene_auto_2"), for: UIControlState.selected)
        self.setSenceBtn.setImage(UIImage(named:"btn_scene_auto_1"), for: UIControlState.normal)
        self.setSenceBtn.addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
        
        
        
 //       self.setFlashBtn.addTarget(self, action: #selector(self.buttopTap), for: UIControlEvents.allEvents)
        

        //MARK:-TAP_TAKE_Photo
        let appl = UIApplication.shared.delegate as! AppDelegate

        
        //
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinch(_:)))
        
 
        self.view.addGestureRecognizer(pinchGesture)
        
        


        if setupSession(){

            setPreview()
            setupFace()
            startSession()
            
            
        }

 
      
 

        
        //去觀察畫面是否轉向
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getter: flashToMain), name: NSNotification.Name(rawValue: "FlshMode"), object: nil)
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postTapOrNot"), object:appl.tapToTakePhoto, queue: nil) { notification in
            if ((appl.tapToTakePhoto)!) == true{
                print("觸碰手勢啟動！！！")
                let singleFinger = UITapGestureRecognizer(target:self,action: #selector(ViewController.tapCapture(_:)))
                
                // 點幾下才觸發 設置 2 時 則是要點兩下才會觸發 依此類推
                singleFinger.numberOfTapsRequired = 2
                
                
                // 幾根指頭觸發
                singleFinger.numberOfTouchesRequired = 1
                
                // 雙指輕點沒有觸發時 才會檢測此手勢 以免手勢被蓋過
                
                // 為視圖加入監聽手勢
                self.view.addGestureRecognizer(singleFinger)
            }else{
                print("觸碰關閉！！")
                
                if let recognizers = self.view.gestureRecognizers {
                    for singleFinger in recognizers {
                        self.view.removeGestureRecognizer(singleFinger as! UIGestureRecognizer)
                    }
                    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinch(_:)))
                    
                    
                    self.view.addGestureRecognizer(pinchGesture)

                }

                /*
                let singleFinger = UITapGestureRecognizer(target:self,action: #selector(ViewController.tapCapture(_:)))
                
                // 點幾下才觸發 設置 2 時 則是要點兩下才會觸發 依此類推
                singleFinger.numberOfTapsRequired = 2
                
                
                // 幾根指頭觸發
                singleFinger.numberOfTouchesRequired = 1
                
                // 雙指輕點沒有觸發時 才會檢測此手勢 以免手勢被蓋過
                
                // 為視圖加入監聽手勢
                self.view.removeGestureRecognizer(singleFinger)
 */
            }
        }


      NotificationCenter.default.addObserver(forName: NSNotification.Name("postSence"), object:appl.indexPath, queue: nil) { notification in
        print((appl.indexPath?.row)!)
        switch ((appl.indexPath?.row)!){
            
        case 0:
            
            self.settingAuto()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_auto_1"), for: UIControlState.normal)

            break
        case 1:
            self.settingAction()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_action_1"), for: UIControlState.normal)
        break
        case 2:
            self.settingHuman()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_portrait_1"), for: UIControlState.normal)

            break
        case 3:
            
            self.settingLandScape()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_landscape_1"), for: UIControlState.normal)

            break
        case 4:
            self.settingNight()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_night_1"), for: UIControlState.normal)

            break
        case 5:
            self.settingNightHuman()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_night_portrait_1"), for: UIControlState.normal)

            break
        case 6:
            self.settingThreater()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_theatre_1"), for: UIControlState.normal)

            break
        case 7:
            self.settingBeach()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_beach_1"), for: UIControlState.normal)

            break
        case 8:
            self.settingSnow()
            
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_snow_1"), for: UIControlState.normal)

            break
        case 9:
            
            self.settingSunset()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_sunset_1"), for: UIControlState.normal)

            break
        case 10:
            self.settingNotshaking()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_steady_photo_1"), for: UIControlState.normal)

            break
        case 11:
            self.settingFireWork()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_firework_1"), for: UIControlState.normal)

            break
        case 12:
            self.settingSport()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_sports_1"), for: UIControlState.normal)

            break
        case 13:
            self.settingParty()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_party_1"), for: UIControlState.normal)

            break
        case 14:
            self.settingCandle()
            self.setSenceBtn.setImage(UIImage(named:"btn_scene_candlelight_1"), for: UIControlState.normal)

            break

            
            
        default: break
            break
        }
        print(appl.indexPath!)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postFlash"), object:appl.valueFromFlash, queue: nil) { notification in
            
            switch((appl.valueFromFlash?.row)!){
            case 0:
                
                //["btn_flash_auto_1","btn_flash_on_1","btn_flash_redeye_1","btn_flash_off_1","btn_flash_light_1"]
                self.setFlashAuto()
                self.setFlashBtn.setImage(UIImage(named:"btn_flash_auto_1"), for: UIControlState.normal)

                break
            case 1:
                self.setFlashOn()
                self.setFlashBtn.setImage(UIImage(named:"btn_flash_on_1"), for: UIControlState.normal)

                break
            case 2:
                self.setFlashOn()
                self.setFlashBtn.setImage(UIImage(named:"btn_flash_redeye_1"), for: UIControlState.normal)

                break
            case 3:
                self.setFlashOff()
                self.setFlashBtn.setImage(UIImage(named:"btn_flash_off_1"), for: UIControlState.normal)

                break
            case 4:
                self.setTorchOn()
                self.setFlashBtn.setImage(UIImage(named:"btn_flash_light_1"), for: UIControlState.normal)

                break
            default:
                break
            
            }
        
        
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postWhiteBalance"), object:appl.valueFromFlash, queue: nil) {notification in
            switch((appl.valueFromWhiteBalance?.row)!){
            case 0:
                self.setWBAuto()
                break
            case 1:
                self.setWBDark()
                break
            case 2:
                self.setWBCloudy()
                break
            case 3:
                self.setWBSunny()
                break
            case 4:
                self.setWBLight()
                
                break
            case 5:
                self.setWBYellowLight()
                break
            case 6:
                self.setWBSunset()
                break
            case 7:
                self.setWBWormLight()
                break
            default:
                break
                
            
            }

        
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postEV"), object:appl.valueFromEV, queue: nil) { notification in
            let device = self.activeInput.device
            do {
                try device?.lockForConfiguration()
                device?.setExposureTargetBias((Float(appl.valueFromEV!)), completionHandler: nil)
                device?.unlockForConfiguration()
            } catch let error {
                NSLog("Could not lock device for configuration: \(error)")
            }

        print(appl.valueFromEV!)
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("postSize"), object:appl.valueFromFlash, queue: nil) { notification in
            switch ((appl.valueFromSize?.row)!){
                
            case 0:
                self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720

                break
            case 1:
                self.captureSession.sessionPreset = AVCaptureSessionPresetMedium

                break
                
            case 2:
                self.captureSession.sessionPreset = AVCaptureSessionPresetMedium

                break
            case 3:
                self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080

                break
            case 4:
                
                self.captureSession.sessionPreset = AVCaptureSessionPresetHigh

                break
            default:
                break
            
            
            }

        
        }


    
    }
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

