//
//  ColorQRScanner.swift
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/15/23.
//

import SwiftUI
import AVFoundation

class QRScannerController: UIViewController {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Set the input device on the capture session.
        captureSession.addInput(videoInput)
        
        // Initialize a AVCaptureVideoDataOutput object and set it as the output device to the capture session.
        let captureVideoDataOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureVideoDataOutput)
        
        captureVideoDataOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue.main)
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

struct ColorQRScanner: UIViewControllerRepresentable {
    @Binding var result: String
    let controller = QRScannerController()
    @State private var isCameraRunning: Bool = true
    
    func makeUIViewController(context: Context) -> QRScannerController {
        let coordinator = Coordinator(result: $result)
        controller.delegate = coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
        if !result.isEmpty && isCameraRunning {
            controller.captureSession.stopRunning()
            self.isCameraRunning = false
        } else if result.isEmpty && !isCameraRunning {
            DispatchQueue.global(qos: .background).async {
                controller.captureSession.startRunning()
            }
            self.isCameraRunning = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(result: $result)
    }
}

class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Binding var scanResult: String
    let jabcodeDecoder = JabcodeDecoder()
    
    init(result: Binding<String>) {
        _scanResult = result
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !self.scanResult.isEmpty {
            return
        }
        DispatchQueue.global().async {
            let videoOrientation = connection.videoOrientation
            
            // Convert the captured sample buffer to a UIImage
            if let image = imageFromSampleBuffer(sampleBuffer, videoOrientation: videoOrientation) {
                
                if let res = self.jabcodeDecoder.decode(image) {
                    self.scanResult = res;
                }
            } else {
                self.scanResult = ""
            }
            
            CMSampleBufferInvalidate(sampleBuffer)
        }
    }
}

func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer, videoOrientation: AVCaptureVideoOrientation) -> UIImage? {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        return nil
    }
    
    let ciImage = CIImage(cvImageBuffer: imageBuffer)
    let context = CIContext()
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
        return nil
    }
    
    let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
    
    return uiImage
}


extension UIImage.Orientation {
    static func from(_ videoOrientation: AVCaptureVideoOrientation) -> UIImage.Orientation {
        switch videoOrientation {
        case .portrait:
            return .right
        case .portraitUpsideDown:
            return .left
        case .landscapeLeft:
            return .up
        case .landscapeRight:
            return .down
        default:
            return .up
        }
    }
}
