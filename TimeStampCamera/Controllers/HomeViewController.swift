//
//  ViewController.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 04/04/22.
//
import UIKit
import AVKit
import CoreLocation
import MaterialComponents.MaterialBottomSheet
import ImageIO
import AssetsLibrary
import Photos
import AudioToolbox

class HomeViewController: UIViewController, MDCBottomSheetControllerDelegate,AVCapturePhotoCaptureDelegate,AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnShortCuts: UIButton!
    @IBOutlet weak var btnChangeCameraView: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var moreItemMenu: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnMoreItem: UIButton!
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    
    @IBOutlet weak var photoLibrary: UIImageView!
    
    @IBOutlet weak var PhotoView: UIView!
    @IBOutlet weak var segmentCameraMode: UISegmentedControl!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cameraView: GridViews!
    
    @IBOutlet weak var lblLongLat: UILabel!
    @IBOutlet weak var currnetDate_Time: UILabel!
    
    var captureSession:AVCaptureSession!
    var captureFileOutput:AVCaptureFileOutput!
    var VideocaptureSession:AVCaptureSession!
    var PhotoCapture:AVCapturePhotoOutput!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var movieOutput = AVCaptureMovieFileOutput()
    var activeInput:AVCaptureDeviceInput?
    var captureDevice:AVCaptureDevice?
    var whiteBalanceModes:AVCaptureDevice.WhiteBalanceGains?
    var outputURL: URL!
    
    var locatioManeger = CLLocationManager()
    var zoomScale = CGFloat(1.0)
    var beginZoomScale = CGFloat(1.0)
    var maxZoomScale = CGFloat(1.0)
    var timeMin = 0
    var timeSec = 0

    weak var timer: Timer?
    let TimerLabel = UILabel(text: "1", font: UIFont(name: "Helvetica Neue", size: 35), textColor: nil, textAlligment: .center)
    let VideoTimer = UILabel(text: "0", font: UIFont(name: "Helvetica Neue", size: 25), textColor: nil, textAlligment: .center)
    let record_dot = UIImageView(placeHolderImage: UIImage(named: "recording_dot"))
    let pauseButton = UIButton()
    let datelabel = UILabel(text: "20/05/2022", font: nil, textColor: nil, textAlligment: nil)
    let camWaterMark = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPause.isHidden = true
        photoLibrary.layer.cornerRadius = photoLibrary.frame.size.height/2
        photoLibrary.layer.borderWidth = 1
        photoLibrary.layer.borderColor = UIColor.clear.cgColor
        photoLibrary.clipsToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true
        VideoTimer.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        TimerLabel.isHidden = true
        record_dot.isHidden = true
        btnLocation.alpha = 0
        datelabel.translatesAutoresizingMaskIntoConstraints = false
       
        menuView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
        OpneimageGallery()
        VideoTimer.isHidden = true
        camWaterMark.backgroundColor = .clear
        cameraView.addSubview(TimerLabel)
        topView.addSubview(VideoTimer)
        topView.addSubview(record_dot)
        //cameraView.addSubview(camWaterMark)
        //camWaterMark.frame.size = cameraView.frame.size
       // camWaterMark.addSubview(datelabel)
        TimerLabel.pin(top: cameraView.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: cameraView.centerXAnchor, centerY: nil, padding: .init(top: 300, left: 0.0, bottom: 0.0, right: 0.0), size: .init(width: 80, height: 50))
       // datelabel.pin(top: camWaterMark.topAnchor, leading: camWaterMark.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 20, left: 10, bottom: 0.0, right: 0.0))
        VideoTimer.pin(top: topView.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: topView.centerXAnchor, centerY: nil, padding: .init(top: 3, left: 0.0, bottom: 0.0, right: 0.0), size: .init(width: 120, height: 50))
        
        record_dot.pin(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: topView.centerYAnchor, padding: .init(top: 0.0, left: 130, bottom: 0.0, right: 0.0), size: .init(width: 20, height: 20))
        
        NotificationCenter.default.addObserver(self,selector:#selector(didSetGridLine(_:)),name: NSNotification.Name.gridLines,object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(didSelectWhiteBalance(_:)),name: NSNotification.Name.whiteBalance,object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(didChangeFocusMode(_:)),name: NSNotification.Name.focusMode,object: nil)
        let captureTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFocus(_:)))
        captureTapGesture.numberOfTapsRequired = 1
        captureTapGesture.numberOfTouchesRequired = 1
        self.cameraView.addGestureRecognizer(captureTapGesture)
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
        print("viewWillAppear_HomeViewController")
        userDefaults.integer(forKey:"setTimer")
        userDefaults.integer(forKey:"flashOnOff")
        userDefaults.string(forKey:"selectedStorege")
        DateTimeSetup()
        LocationSetup()
        if userDefaults.bool(forKey: "isLocation") == true {
            getLocation()
        }
        self.navigationController?.navigationBar.isHidden = true
        if segmentCameraMode.selectedSegmentIndex == 0 {
            let alpha = UserDefaults.standard.float(forKey: "alpha")
            btnLocation.alpha = CGFloat(alpha)
        }
        fetchPhotos()
    }
    
    //MARK:- Fetch last captured image -
    
    func fetchPhotos () {
            // Sort the images by descending creation date and fetch the first 3
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
            if fetchResult.count > 0 {
                let totalImageCountNeeded = 1 // <-- The number of images to fetch
                fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
            }
        }
        func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                if let image = image {
                    self.photoLibrary.image = image
                }
                if index + 1 < fetchResult.count && self.photoLibrary.image.hashValue < totalImageCountNeeded {
                    self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
                } else {
                    print("Completed array: \(String(describing: self.photoLibrary.image))")
                }
            })
        }
    
    @objc func didTapFocus(_ recognizeGesture: UITapGestureRecognizer) {
        let touchPoint: CGPoint = recognizeGesture.location(in: self.cameraView)
        //GET PREVIEW LAYER POINT
        guard let previewLayer = previewLayer else { return }
        
        let convertedPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
        //Assign Auto Focus and Auto Exposour
        if let device = captureDevice {
            do {
                try! device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    //Add Focus on Point
                    device.focusPointOfInterest = convertedPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                //                    if device.isExposurePointOfInterestSupported{
                //                        //Add Exposure on Point
                //                        device.exposurePointOfInterest = convertedPoint
                //                        device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                //                    }
                device.unlockForConfiguration()
            }
        }
    }

     func grid(columns:Int, row:Int) {
        cameraView.numberOfColumns = columns
        cameraView.numberOfRows = row
    }
    
    @objc func didSetGridLine(_ notification: Notification) {
        let dict = notification.userInfo as! [String:Any]
        if let index = dict["index"] as? Int {
            if index == 0 {
                grid(columns: 0, row: 0)
            }else if index == 1 {
                grid(columns: 2, row: 2)
            }else if index == 2 {
               grid(columns: 3, row: 3)
            }
        }
    }
    
    @objc func didChangeFocusMode(_ notification: Notification) {
        let dict = notification.userInfo as! [String:Any]
        if let index = dict["index"] as? Int {
            if index == 0 {
                //
            }else if index == 1 {
             //
            }
        }
    }
    
    private func normalizedGains(_ gains: AVCaptureDevice.WhiteBalanceGains) -> AVCaptureDevice.WhiteBalanceGains {
        var g = gains
        let capDev = captureDevice
        g.redGain = max(1.0, g.redGain)
        g.greenGain = max(1.0, g.greenGain)
        g.blueGain = max(1.0, g.blueGain)
        g.redGain = min(capDev?.maxWhiteBalanceGain ?? 0.0, g.redGain)
        g.greenGain = min(capDev?.maxWhiteBalanceGain ?? 0.0, g.greenGain)
        g.blueGain = min(capDev?.maxWhiteBalanceGain ?? 0.0, g.blueGain)
        return g
    }
    
    private func setWhiteBalanceGains(_ gains: AVCaptureDevice.WhiteBalanceGains) {
        do {
            try self.captureDevice?.lockForConfiguration()
            let normalizedGains = self.normalizedGains(gains) // Conversion can yield out-of-bound values, cap to limits
            self.captureDevice?.setWhiteBalanceModeLocked(with: normalizedGains, completionHandler: nil)
            self.captureDevice?.unlockForConfiguration()
        } catch let error {
            NSLog("Could not lock device for configuration: \(error)")
        }
    }
    
    @objc func didSelectWhiteBalance(_ notification: Notification) {
        let dict = notification.userInfo as! [String:Any]
        if let index = dict["index"] as? Int {
            if index == 0 {
                guard let videoDevice = AVCaptureDevice.default(for: .video) else {return}
                captureDevice = videoDevice
                try! videoDevice.lockForConfiguration()
                videoDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance)
                videoDevice.unlockForConfiguration()
            }else if index == 1 {
                whiteBalanceMode(temp: 2500, tint: 80)
            }else if index == 2 {
                whiteBalanceMode(temp: 4500, tint: 80)
            } else if index == 3 {
                whiteBalanceMode(temp: 5500, tint: 120)
            } else if index == 4 {
                whiteBalanceMode(temp: 7000, tint: 150)
            }
        }
    }
    
    private func whiteBalanceMode(temp:Float, tint:Float) {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {return}
        captureDevice = videoDevice
        try! videoDevice.lockForConfiguration()
        videoDevice.whiteBalanceMode = .locked
        let whiteBalanceGains = videoDevice.deviceWhiteBalanceGains
        var whiteBalanceTemperatureAndTint = videoDevice.temperatureAndTintValues(for: whiteBalanceGains)
        whiteBalanceTemperatureAndTint.temperature = temp
        whiteBalanceTemperatureAndTint.tint = tint
        let temperatureAndTint = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(
            temperature: whiteBalanceTemperatureAndTint.temperature,tint: whiteBalanceTemperatureAndTint.tint)
        setWhiteBalanceGains(videoDevice.deviceWhiteBalanceGains(for: temperatureAndTint))
        videoDevice.unlockForConfiguration()
        print(temperatureAndTint)
    }

    private func DateTimeSetup() {
        if (userDefaults.object(forKey: "coord1") != nil) {
            datelabel.frame.origin = NSCoder.cgPoint(for: userDefaults.value(forKey: "coord1") as! String)
        }
        
        let newPatient = savePosition(xPos: 100, yPos: 100)
        let patientList: [savePosition] = [newPatient]

        do {
            let encodeData = try JSONEncoder().encode(patientList)
            UserDefaults.standard.set(encodeData, forKey: "patientList")
        } catch { print(error) }
        
        if Global.shared.isDateTime == true {
            currnetDate_Time.isHidden = false
        }else{
            currnetDate_Time.isHidden = true
        }
        
        if let dateform = userDefaults.string(forKey: "format") {
            let date = Date().dateToStringConverter(dateFormat: dateform)
            currnetDate_Time.text = date
        }else{
            let date = Date().dateToStringConverter(dateFormat: "dd/MM/yy hh:mm a")
            currnetDate_Time.text = date
        }
        if let color = userDefaults.color(forKey: "dtLabelColor"){
            currnetDate_Time.backgroundColor = color
        }
        if let textColor = userDefaults.color(forKey: "dtTxtColor"){
            currnetDate_Time.textColor = textColor
        }
        if userDefaults.bool(forKey: "isCornerRadius") == true {
            currnetDate_Time.layer.cornerRadius = 8
            currnetDate_Time.clipsToBounds = true
        }else{
            currnetDate_Time.layer.cornerRadius = 0
        }
        
        let fontSize = userDefaults.integer(forKey: "fontSize")
        currnetDate_Time.font = currnetDate_Time.font.withSize(CGFloat(fontSize))
        
        if let stampStyle = userDefaults.string(forKey: "stampStyle") {
            currnetDate_Time.font = UIFont(name: stampStyle, size: CGFloat(fontSize))
        }
    }
    
    private func LocationSetup() {
        if let dateform = userDefaults.string(forKey: "locFormate") {
            lblLongLat.text = dateform
        }else {
            lblLongLat.text = "\(lati(short: true)) \(longi(short: true))"
        }
        
        if userDefaults.bool(forKey: "isLocation") == true {
            lblLongLat.isHidden = false
        }else {
            if Global.shared.isLocation == true {
                lblLongLat.isHidden = false
            }else{
                lblLongLat.isHidden = true
            }
        }

        if let color = userDefaults.color(forKey: "LocLabelColor"){
            lblLongLat.backgroundColor = color
        }
        if let textColor = userDefaults.color(forKey: "LocTxtColor"){
            lblLongLat.textColor = textColor
        }
        if userDefaults.bool(forKey: "isLocCornerRadius") == true {
            lblLongLat.layer.cornerRadius = 8
            lblLongLat.clipsToBounds = true
        }else{
            lblLongLat.layer.cornerRadius = 0
        }
        let fontSize = userDefaults.integer(forKey: "locFontSize")
        lblLongLat.font = lblLongLat.font.withSize(CGFloat(fontSize))
        
        if let stampStyle = userDefaults.string(forKey: "locStampStyle") {
            lblLongLat.font = UIFont(name: stampStyle, size: CGFloat(fontSize))
        }
    }
    
    @objc func didTapView(){
        menuView.isHidden = true
    }
    
    @IBAction func moreItem(_ sender: UIButton) {
        if menuView.isHidden == true {
            menuView.isHidden = false
        } else {
            menuView.isHidden = true
        }
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            print("Video mode")
            btnLocation.alpha = 1
            if setupSession() {
                startSession()
            }
        }else{
            UserDefaults.standard.set(0, forKey: "alpha")
        }
    }
    
    @IBAction func btnAssistiveGrid(_ sender: UIButton) {
        self.bottomSheet(controller: AssistiveGridVC(), width: self.view.frame.width, height: 320)
        menuView.isHidden = true
    }
    
    @IBAction func btnWhiteBalance(_ sender: UIButton) {
        self.bottomSheet(controller: WhiteBalanceVC(), width: self.view.frame.width, height: 370)
        menuView.isHidden = true
    }
    
    @IBAction func btnChooseFolder(_ sender: UIButton) {
        let chooseFoldervc = ChooseFolderVC.instantiateFromStoryboard()
        self.navigationController?.pushViewController(chooseFoldervc, animated: true)
        menuView.isHidden = true
    }
    
    @IBAction func flashSetting(_ sender: UIButton) {
        self.bottomSheet(controller: FlashScreenVC(), width: self.view.frame.width, height: 320)
    }
    @IBAction func timerSetting(_ sender: UIButton) {
        self.bottomSheet(controller: TimerVC(), width: self.view.frame.width, height: 270)
    }
    @IBAction func shortCuts(_ sender: UIButton) {
        self.bottomSheet(controller: ShortcutVC(), width: self.view.frame.width, height: 270)
    }
    @IBAction func setting(_ sender: UIButton) {
        let settingvc = SettingViewController.instantiateFromStoryboard()
        navigationController?.pushViewController(settingvc, animated: true)
    }
    
    @IBAction func pinchZoom(_ sender: UIPinchGestureRecognizer) {
        self.shouldEnablePinchToZoom = true
        print(beginZoomScale)
    }
    
    var shouldEnablePinchToZoom = true {
        didSet {
            zoomGesture.isEnabled = shouldEnablePinchToZoom
        }
    }

    var zoomGesture = UIPinchGestureRecognizer()

    fileprivate func attachZoom(_ view: UIView) {
        DispatchQueue.main.async {
            self.zoomGesture.addTarget(self, action: #selector(self._zoomStart(_:)))
            view.addGestureRecognizer(self.zoomGesture)
            self.zoomGesture.delegate = self
        }
    }

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = zoomScale
        }
        return true
    }

    @objc fileprivate func _zoomStart(_ recognizer: UIPinchGestureRecognizer) {
        guard let view = cameraView,
            let previewLayer = previewLayer
            else { return }

        var allTouchesOnPreviewLayer = true
        let numTouch = recognizer.numberOfTouches

        for i in 0 ..< numTouch {
            let location = recognizer.location(ofTouch: i, in: view)
            let convertedTouch = previewLayer.convert(location, from: previewLayer.superlayer)
            if !previewLayer.contains(convertedTouch) {
                allTouchesOnPreviewLayer = false
                break
            }
        }
        if allTouchesOnPreviewLayer {
            _zoom(recognizer.scale)
        }
    }

    fileprivate func _zoom(_ scale: CGFloat) {
        let device = captureDevice
//        switch captureDevice {
//      case .back:
//              device = backCameraDevice
//         case .fron
//            device = frontCameraDevice
//     }
        do {
            let captureDevice = device
            try captureDevice?.lockForConfiguration()
            zoomScale = max(1.0, min(beginZoomScale * scale, maxZoomScale))
            captureDevice?.videoZoomFactor = zoomScale
            captureDevice?.unlockForConfiguration()
        } catch {
            print("Error locking configuration")
        }
    }
}

//MARK:- CAMERA SETUP -

extension HomeViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //checkPermissions()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        guard let backcamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("unable to access camera")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backcamera)
            PhotoCapture = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(PhotoCapture) {
                captureSession.addInput(input)
                captureSession.addOutput(PhotoCapture)
                setupLivePreview()
            }
        }
        catch let error {
            print("Error Unable to initialize back camera:\(error.localizedDescription)")
        }
    }

    func setupLivePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspect
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.addSublayer(lblLongLat.layer)
        previewLayer.addSublayer(currnetDate_Time.layer)
        previewLayer.addSublayer(TimerLabel.layer)
        previewLayer.addSublayer(datelabel.layer)
        cameraView.layer.addSublayer(previewLayer)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.previewLayer.frame.size = self.cameraView.frame.size
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        if let image = UIImage(data: imageData) {
            photoLibrary.image = image
            let drawDateTime = imageWithText(image: image, dateLabel: currnetDate_Time)
            UIImageWriteToSavedPhotosAlbum(drawDateTime, nil, nil, nil)
        }
    }
    
    func writeImageToPath(_ path:String, image:UIImage) {
        let uploadURL = URL.createFolder(folderName: "upload")!.appendingPathComponent(path)

        if !FileManager.default.fileExists(atPath: uploadURL.path) {
                print("File does NOT exist -- \(uploadURL) -- is available for use")
                let data = image.jpegData(compressionQuality: 0.9)
                do {
                    print("Write image")
                    try data!.write(to: uploadURL)
                }
                catch {
                    print("Error Writing Image: \(error)")
                }
            }
            else {
                print("This file exists -- something is already placed at this location")
            }
        }

    func imageWithText(image : UIImage, dateLabel : UILabel) -> UIImage {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width / 2, height: image.size.height / 2))
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: outerView.frame.width, height: outerView.frame.height))
        imgView.image = image
        outerView.addSubview(imgView)
        outerView.addSubview(dateLabel)
        let renderer = UIGraphicsImageRenderer(size: outerView.bounds.size)
        let convertedImage = renderer.image { ctx in
            outerView.drawHierarchy(in: outerView.bounds, afterScreenUpdates: true)
        }
        return convertedImage
    }
    
    @IBAction func CapturePhoto(_ sender: UIButton) {
        if segmentCameraMode.selectedSegmentIndex == 0 {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
            AudioServicesPlaySystemSound(1108)
            
            if userDefaults.integer(forKey: "setTimer") == 0 || UserDefaults.standard.integer(forKey: "flashOnOff") == 1 || UserDefaults.standard.integer(forKey: "flashOnOff") == 2{
                var secondsRemaining = 3
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining > 0 {
                        self.TimerLabel.isHidden = false
                        self.TimerLabel.text = String(secondsRemaining)
                        print ("\(secondsRemaining) seconds")
                        secondsRemaining -= 1
                    } else {
                        self.TimerLabel.isHidden = true
                        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                        if UserDefaults.standard.integer(forKey: "flashOnOff") == 1 {
                            settings.flashMode = .on
                            print(settings.flashMode = .on)
                        }
                        if UserDefaults.standard.integer(forKey: "flashOnOff") == 2 {
                            settings.flashMode = .auto
                            print(settings.flashMode = .auto)
                        }
                        self.PhotoCapture.capturePhoto(with: settings, delegate: self)
                        Timer.invalidate()
                    }
                }
            } else if userDefaults.integer(forKey: "setTimer") == 1 || UserDefaults.standard.integer(forKey: "flashOnOff") == 2 {
                var secondsRemaining = 5
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining > 0 {
                        self.TimerLabel.isHidden = false
                        self.TimerLabel.text = String(secondsRemaining)
                        print ("\(secondsRemaining) seconds")
                        secondsRemaining -= 1
                    } else {
                        self.TimerLabel.isHidden = true
                        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                        if UserDefaults.standard.integer(forKey: "flashOnOff") == 1 {
                            settings.flashMode = .on
                            print(settings.flashMode = .on)
                        }
                        if UserDefaults.standard.integer(forKey: "flashOnOff") == 2 {
                            settings.flashMode = .auto
                            print(settings.flashMode = .auto)
                        }
                        self.PhotoCapture.capturePhoto(with: settings, delegate: self)
                        Timer.invalidate()
                    }
                }
            } else if userDefaults.integer(forKey: "setTimer") == 2 || UserDefaults.standard.integer(forKey: "flashOnOff") == 0 || UserDefaults.standard.integer(forKey: "flashOnOff") == 1 || UserDefaults.standard.integer(forKey: "flashOnOff") == 2 {
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                if UserDefaults.standard.integer(forKey: "flashOnOff") == 0 {
                    settings.flashMode = .off
                    print(settings.flashMode = .off)
                }else if UserDefaults.standard.integer(forKey: "flashOnOff") == 1 {
                    settings.flashMode = .on
                    print(settings.flashMode = .on)
                }else if UserDefaults.standard.integer(forKey: "flashOnOff") == 2 {
                    settings.flashMode = .auto
                    print(settings.flashMode = .auto)
                }
                PhotoCapture.capturePhoto(with: settings, delegate: self)
            }
        }else{
            btnFlash.isHidden = true
            btnSetting.isHidden = true
            btnTimer.isHidden = true
            PhotoView.isHidden = true
            btnMoreItem.isHidden = true
            btnShortCuts.isHidden = true
            photoLibrary.isHidden = true
            btnChangeCameraView.isHidden = true
            btnLocation.isHidden = true
            VideoTimer.isHidden = false
            record_dot.isHidden = false
            btnPause.isHidden = false
            btnCamera.setImage(UIImage(named: "record"), for: .normal)
            VideoTimer.text = String(format: "%02d:%02d", timeMin, timeSec)
           
            var isRecording = false
            if !isRecording {
                isRecording = true
                startRecording()
                startTimer()
            }
        }
    }
    
    @IBAction func pauseRecording(_ sender: UIButton) {

        
    }
    
// MARK:- Video Timer -
    
    func startTimer(){
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        VideoTimer.text = timeNow
        stopTimer() // stop it at it's current time before starting it again
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    func timerTick(){
        timeSec += 1
        if timeSec == 60{
            timeSec = 0
            timeMin += 1
        }
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        VideoTimer.text = timeNow
    }
    func resetTimerToZero(){
        timeSec = 0
        timeMin = 0
        stopTimer()
    }
    func resetTimerAndLabel(){
        resetTimerToZero()
        VideoTimer.text = String(format: "%02d:%02d", timeMin, timeSec)
    }
    func  stopTimer(){
        timer?.invalidate()
    }
    
//MARK:-
    
    @IBAction func switchCamera(_ sender: UIButton) {
        if let session = captureSession {
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            session.beginConfiguration()
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    session.removeInput(input)
                }
            }
            //  session.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(.front)
                    print("font")
                    self.showToast(message: "Switched to fromt Camera!", font: .systemFont(ofSize: 17,weight: .semibold))
                } else {
                    newCamera = cameraWithPosition(.back)
                    print("rear")
                    self.showToast(message: "Switched to back Camera!", font: .systemFont(ofSize: 17,weight: .semibold))
                }
            }
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err!.localizedDescription)")
            } else {
                let seconds = 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    session.addInput(newVideoInput)
                }
            }
            session.commitConfiguration()
        }
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
//    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touchPoint = touches.first as! UITouch
//        let screenSize = cameraView.bounds.size
//        let focusPoint = CGPoint(x: touchPoint.location(in: cameraView).y / screenSize.height, y: 1.0 - touchPoint.location(in: cameraView).x / screenSize.width)
//
//        if let device = captureDevice {
//            if device.isFocusPointOfInterestSupported {
//                device.focusPointOfInterest = focusPoint
//                device.focusMode = AVCaptureDevice.FocusMode.autoFocus
//            }
//            if device.isExposurePointOfInterestSupported {
//                device.exposurePointOfInterest = focusPoint
//                device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
//            }
//            device.unlockForConfiguration()
//        }
//    }
    
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:{ (authorized) in
                if(!authorized){
                    abort() // APP CRASH
                }
            })
        case .restricted:
            abort()
        @unknown default:
            fatalError()
        }
    }
    
    //MARK:-------------------- VIDEO MODE -------------------------------
    
    func setupSession() -> Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.iFrame1280x720
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)!
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.inputs.isEmpty {
                self.captureSession.addInput(input)
            }
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        return true
    }
    func setupCaptureMode(_ mode: Int) {
        // Video Mode
    }
    
    //MARK:- Camera Session
    func startSession() {
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
                self.previewLayer.frame = self.cameraView.bounds
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
        return DispatchQueue.main
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
    
    func startCapture() {
        startRecording()
    }
       
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    func startRecording() {
        if movieOutput.isRecording == false {
            let connection = movieOutput.connection(with: AVMediaType.video)
            if ((connection?.isVideoOrientationSupported) != nil) {
                connection?.videoOrientation = currentVideoOrientation()
            }
            if ((connection?.isVideoStabilizationSupported) != nil) {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            let device = activeInput?.device
            if ((device?.isSmoothAutoFocusSupported) != nil) {
                do {
                    try device?.lockForConfiguration()
                    device?.isSmoothAutoFocusEnabled = false
                    device?.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
            }
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
        else {
            stopRecording()
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            
            let cleanup: ()->() = {
                if FileManager.default.fileExists(atPath: outputFileURL.path) {
                    do {
                        try FileManager.default.removeItem(at: outputFileURL)
                    } catch _ {}
                }
            }

            self.stopTimer()
            if let path = userDefaults.string(forKey: "selectedStorege") {
                cleanup()
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
                    btnFlash.isHidden = false
                    btnSetting.isHidden = false
                    btnTimer.isHidden = false
                    btnMoreItem.isHidden = false
                    btnShortCuts.isHidden = false
                    photoLibrary.isHidden = false
                    btnChangeCameraView.isHidden = false
                    btnLocation.isHidden = false
                    VideoTimer.isHidden = true
                    PhotoView.isHidden = false
                    btnPause.isHidden = true
                    record_dot.isHidden = true
                    btnCamera.setImage(UIImage(named: "Camera"), for: .normal)
                    self.stopTimer()
                    print(path)
                }
            }
            
//            UISaveVideoAtPathToSavedPhotosAlbum(DefaultPath!.path, nil, nil, nil)
//            print(DefaultPath!.path)
//            if let path = userDefaults.string(forKey: "selectedStorege") {
//                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
//                    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
//                    btnFlash.isHidden = false
//                    btnSetting.isHidden = false
//                    btnTimer.isHidden = false
//                    btnMoreItem.isHidden = false
//                    btnShortCuts.isHidden = false
//                    photoLibrary.isHidden = false
//                    btnChangeCameraView.isHidden = false
//                    btnLocation.isHidden = false
//                    VideoTimer.isHidden = true
//                    PhotoView.isHidden = false
//                    btnPause.isHidden = true
//                    record_dot.isHidden = true
//                    btnCamera.setImage(UIImage(named: "Camera"), for: .normal)
//                    self.stopTimer()
//                    print(path)
//                }
//            }
        }
    }
    
    func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            print(video)
        }
    }
}

//MARK:- LOCATION SETUP -

extension HomeViewController:CLLocationManagerDelegate {
    
    func getLocation() {
        locatioManeger.requestAlwaysAuthorization()
        locatioManeger.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locatioManeger.delegate = self
            locatioManeger.desiredAccuracy = kCLLocationAccuracyBest
            locatioManeger.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        let latit = locValue.latitude
        let longit = locValue.longitude
        let latVal = String(format:"%.4f", latit)
        let longVal = String(format:"%.4f", longit)
        Global.shared.longitude = Double(latVal)!
        Global.shared.latitude = Double(longVal)!
        if let dateform = userDefaults.string(forKey: "locFormate") {
            lblLongLat.text = dateform
        }else {
            lblLongLat.text = "\(lati(short: true)) \(longi(short: true))"
        }
    }
}

//MARK:- IMAGE GALLERY -

extension HomeViewController {
    func OpneimageGallery(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(galeryImgTapped))
        photoLibrary.addGestureRecognizer(tapGesture)
        photoLibrary.isUserInteractionEnabled = true
    }
    @objc func galeryImgTapped(){
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
}
