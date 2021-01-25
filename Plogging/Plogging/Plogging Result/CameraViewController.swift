//
//  CameraViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private let cameraFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var currentCamera = Camera.back.position
    var baseImage: UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.renderingCameraPhoto {
            guard let PloggingResultPhotoViewController = segue.destination as? PloggingResultPhotoViewController else {
                return
            }
            PloggingResultPhotoViewController.baseImage = baseImage
        }
    }
   
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        currentCamera = currentCamera == Camera.back.position ? Camera.front.position : Camera.back.position
        showCameraInView()
    }
}

// MARK: Life Cycle
extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraFrameView)
        setUpCameraFrameViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPloggingResultInfoView()
        showCameraInView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}

// MARK: Camera Layout Setting
private extension CameraViewController {
    func setUpCameraFrameViewLayout() {
        cameraFrameView.widthAnchor.constraint(equalToConstant: DeviceInfo.screenWidth).isActive = true
        cameraFrameView.heightAnchor.constraint(equalToConstant: DeviceInfo.screenWidth).isActive = true
        cameraFrameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addPloggingResultInfoView() {
        let ploggingInfoViewCreater = PloggingInfoViewCreater()
        // 거리 시간 전달 필요
        let ploggingInfoView = ploggingInfoViewCreater.createFloggingInfoView(2.13, "13:30")
        ploggingInfoView.frame = CGRect(x: 0, y: cameraFrameView.frame.origin.y, width: 0, height: 0)
        view.addSubview(ploggingInfoView)
    }
    
    func showCameraInView() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        var inputCamera: AVCaptureDevice
        
        do {
            if currentCamera == Camera.back.position {
                guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
                    return
                }
                inputCamera = backCamera
            } else {
                guard let frontCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front) else {
                    return
                }
                inputCamera = frontCamera
            }
            
            let backCameraInput = try AVCaptureDeviceInput(device: inputCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(backCameraInput) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(backCameraInput)
                captureSession.addOutput(stillImageOutput)
                setUpLivePreview()
            }
        }
        catch let error {
            print("Error Unable to initialize back camera: \(error.localizedDescription)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraFrameView.bounds
            }
        }
    }
    
    func setUpLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraFrameView.layer.addSublayer(videoPreviewLayer)
    }
}

// MARK: AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        guard let capturedImage = UIImage(data: imageData) else {
            return
        }
        let resizedCapturedImage = capturedImage.resize(targetSize: CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenWidth))
        UIImageWriteToSavedPhotosAlbum(resizedCapturedImage, nil, nil, nil)
        baseImage = resizedCapturedImage
        self.performSegue(withIdentifier: SegueIdentifier.renderingCameraPhoto, sender: nil)
    }
}
