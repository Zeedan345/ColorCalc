//
//  FrameHandler.swift
//  ColorCalc
//
//  Created by Zeedan Feroz Khan on 5/25/25.
//

import AVFoundation
import CoreImage

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var greenValues: [CGFloat] = []
    
    private var permissionGranted = false
    private var isCapturing = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func startCapturing() {
        greenValues = []
        isCapturing = true
    }
    func stopCapturing() {
        isCapturing = false
    }
    func resetGreenValues() {
        greenValues = []
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.permissionGranted = true
                
            case .notDetermined: // The user has not yet been asked for camera access.
                self.requestPermission()
                
        // Combine the two other cases into the default case
        default:
            self.permissionGranted = false
        }
    }
    func requestPermission() {
        // Strong reference not a problem here but might become one in the future.
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else {return }
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
    }
}
extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        frameCOunt
        let avgGreen = averageGreen(in: cgImage)
        
        // All UI updates should be/ must be performed on the main queue.
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
            if isCapturing {
                self.greenValues.append(avgGreen)
            }
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    private func averageGreen(in cgImage: CGImage) -> CGFloat {
        guard let data = cgImage.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else {return 0}
        
        let bytesPerPixel = cgImage.bitsPerPixel/8
        let width = cgImage.width
        let height = cgImage.height
        let pixelCount = width*height
        
        var greenTotal: CGFloat = 0
        
        for i in 0..<pixelCount{
            let pixelOffset = i * bytesPerPixel
            let g = CGFloat(ptr[pixelOffset + 1])
            greenTotal += g
        }
        
        return greenTotal / CGFloat(pixelCount)
    }
}
