//
//  ViewController.swift
//  TimeStampCamera
//
//  Created by mahesh gelani on 04/04/22.
//
import UIKit
import AVKit
import MaterialComponents.MaterialBottomSheet

class MainViewController: UIViewController, MDCBottomSheetControllerDelegate,AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var photoLibrary: UIImageView!
    @IBOutlet weak var cameraView: UIView!

    var captureSession:AVCaptureSession!
    var PhotoCapture:AVCapturePhotoOutput!
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var currnetDate_Time: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let timeString = dateFormatter.string(from: date)
        currnetDate_Time.text = timeString
        
        photoLibrary.layer.borderWidth = 1
        photoLibrary.layer.masksToBounds = false
        photoLibrary.layer.borderColor = UIColor.black.cgColor
        photoLibrary.layer.cornerRadius = photoLibrary.frame.height/2
        photoLibrary.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
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
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspect
        previewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(previewLayer)
        
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        DispatchQueue.main.async {
            self.previewLayer.frame = self.cameraView.bounds
        }
    }
    
    @IBAction func timerSetting(_ sender: UIButton) {
        let viewController: FlashScreenVC = FlashScreenVC()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.preferredContentSize = CGSize(width: 414, height: 300)
        bottomSheet.delegate = self
        bottomSheet.dismissOnDraggingDownSheet = true
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @IBAction func moreItem(_ sender: UIButton) {
    }
    
    @IBAction func flashSetting(_ sender: UIButton) {
        let viewController: FlashScreenVC = FlashScreenVC()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.preferredContentSize = CGSize(width: 414, height: 300)
        bottomSheet.delegate = self
        bottomSheet.dismissOnDraggingDownSheet = true
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @IBAction func setting(_ sender: UIButton) {
        let settingvc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(settingvc, animated: true)
    }
    
    
    @IBAction func shortCuts(_ sender: UIButton) {
        let viewController: FlashScreenVC = FlashScreenVC()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.preferredContentSize = CGSize(width: 414, height: 300)
        bottomSheet.delegate = self
        bottomSheet.dismissOnDraggingDownSheet = true
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        
    }
    
    @IBAction func Startcamera(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        PhotoCapture.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        let image = UIImage(data: imageData)
        photoLibrary.image = image
    }
}
