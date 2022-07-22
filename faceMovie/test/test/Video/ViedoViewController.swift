//
//  ViedoViewController.swift
//  test
//
//  Created by cyanboo on 2022/7/13.
//
import AVFoundation
import UIKit
import Vision

class ViedoViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet var videoButton: UIButton!
    var queue: dispatch_queue_global_t!
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
    }

    func creatConfigureSession() {
        //     AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        guard var captureDevice = AVCaptureDevice.default(for: .video) else { return  }
//        var videoInput: AVCaptureDeviceInput = throw AVCaptureDeviceInput.init(device: captureDevice)
        let sessions = AVCaptureSession()

        
        
        do {
          let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
            sessions.addInput(cameraInput)
            
            
        } catch {
          fatalError(error.localizedDescription)
        }
        
        /**
         AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
         [videoOutput setSampleBufferDelegate:self queue:_queue];
         */
    }
    
}



