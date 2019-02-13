//
//  ViewController.swift
//  multiple_windows
//
//  Created by Masoud Sasha on 2/12/19.
//  Copyright © 2019 Masoud Sasha. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()

    }

    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            self.captureDevice = captureDevice
            beginSession()
        }
    }
    
    func beginSession () {
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
        }catch{
            print(error.localizedDescription)
        }
        

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String):NSNumber(value: kCVPixelFormatType_32BGRA)]
        
        if captureSession.canAddOutput(dataOutput){
            captureSession.addOutput(dataOutput)
        }
    
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.MasoudSasha.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                
                photoVC.takenPhoto = image
                
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.stopCaptureSession()
                    })
                    
                }
            }
            
            
        }
    }
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        
        return nil
    }
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
    
    
}

