//
//  CameraViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice?
    var baseImage: UIImage?
  
    let cameraFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraFrameView)
        setUpCameraFrameViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPloggingResultInfoView()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        do {
            guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
                print("Unable to access backCamera")
                return
            }
            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("Unable to access frontCamera")
                return
            }
            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(backCameraInput) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(backCameraInput)
                captureSession.addOutput(stillImageOutput)
                setUpLivePreview()
            }
        }
        catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraFrameView.bounds
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    // MARK: IBAction
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setUpCameraFrameViewLayout() {
        cameraFrameView.widthAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        cameraFrameView.heightAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        cameraFrameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cameraFrameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func addPloggingResultInfoView() {
        let ploggingInfoViewCreater = PloggingInfoViewCreater()
        // 거리 시간 전달 필요
        let ploggingInfoView = ploggingInfoViewCreater.createFloggingInfoView(2.13, "13:30")
        ploggingInfoView.frame = CGRect(x: 0, y: cameraFrameView.frame.origin.y, width: 0, height: 0)
        view.addSubview(ploggingInfoView)
    }
    
    func setUpLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraFrameView.layer.addSublayer(videoPreviewLayer)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let capturedImage = UIImage(data: imageData)
        baseImage = capturedImage
        self.performSegue(withIdentifier: "renderingCameraPhoto", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "renderingCameraPhoto" {
            guard let PloggingResultPhotoViewController = segue.destination as? PloggingResultPhotoViewController else {
                return
            }
            PloggingResultPhotoViewController.baseImage = baseImage
        }
    }
}
