//
//  TestViedo.swift
//  test
//
//  Created by cyanboo on 2022/7/13.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import Vision
import AVKit

class TestViedo: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    ///录像
    // 录像按钮
    var recordButton: UIButton!
    // 正在录音
    var isRecording = false
    //最大允许的录制时间（秒）
    let totalSeconds: Float64 = 10.00
    //每秒帧数
    var framesPerSecond:Int32 = 15
    //保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    //    let movieDevice = AVCaptureDevice.default(for: .audio
    //音频输入设备
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    
    ///脸部识别
    let session = AVCaptureSession()
    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    var faceViewHidden = false
    var maxX: CGFloat = 0.0
    var midY: CGFloat = 0.0
    var maxY: CGFloat = 0.0
    var sequenceHandler = VNSequenceRequestHandler()
    var videoOutputFace = AVCaptureVideoDataOutput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                setupFace()
        //        otherVC()
        // 设置预览画面
        setUpPreview()
        session.startRunning()
    }
    
    
    @objc func onClickRecordButton(sender: UIButton) {
        session.stopRunning()
        if !isRecording {
            printLog(isRecording)
            // 録画開始
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String? = "\(documentsDirectory)/temp.mp4"
            let fileURL :NSURL = NSURL(fileURLWithPath: filePath!)
            
            fileOutput.startRecording(to: fileURL as URL, recordingDelegate:self)
            isRecording=true
            changeButtonColor(target:recordButton, color:UIColor.red)
            recordButton.setTitle("録画中", for: .normal)
            self.captureSession.startRunning()

        } else {
            printLog(isRecording)
            // 録画終了
            fileOutput.stopRecording()
            isRecording=false
            changeButtonColor(target:recordButton, color:UIColor.gray)
            recordButton.setTitle("録画開始", for: .normal)
        }
    }
    
    func changeButtonColor(target:UIButton, color:UIColor) {
        target.backgroundColor = color
    }
    
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didStartRecordingTo fileURL: URL,
                    from connections: [AVCaptureConnection]) {
        printLog(output)
    }
    
    func fileOutput(_ output:AVCaptureFileOutput, didFinishRecordingTo outputFileURL:URL, from connections: [AVCaptureConnection], error:Error?) {
        printLog(output)
        //        // ライブラリへ保存
        //        PHPhotoLibrary.shared().performChanges({
        //            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        //        }) { completed, error in
        //            if completed {
        //                print("Video is saved!")
        //            }
        //        }
        var message:String!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            //            Data(contentsOfurl)
            //            let data = NSData(contentsOf: outputFileURL)
            //            print(data)
            printLog(outputFileURL)
            
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                message = "保存成功!"
            } else{
                message = "保存失败：\(error!.localizedDescription)"
            }
            
            DispatchQueue.main.async {
                //弹出提示框
                let alertController = UIAlertController(title: message, message: nil,
                                                        preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { alert in
                    self.reviewRecord(outputURL: outputFileURL)
                })
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    
    func detectedFace(request: VNRequest, error: Error?) {
        // 1
        guard
            let results = request.results as? [VNFaceObservation],
            let result = results.first
        else {
            // 2
            //          faceView.clear()
            print("🔴 = " + #function)
            return
        }
        
        //      if faceViewHidden {
        //        updateLaserView(for: result)
        //      } else {
        //        updateFaceView(for: result)
        //      }
    }
    
    
}

//人脸
extension TestViedo: AVCaptureVideoDataOutputSampleBufferDelegate {
    // 人脸识别
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 1
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("🔴 = " + #function)
            //未识别到
            return
        }
        print("🟣")
        
        // 2
        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
        
        // 3
        do {
            try sequenceHandler.perform(
                [detectFaceRequest],
                on: imageBuffer,
                orientation: .leftMirrored)
            print("🟢 = " + #function)
            
        } catch {
            print("🔴 = " + #function)
            
            print(error.localizedDescription)
        }
    }
    
    func setupFace() {
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back) else {
            fatalError("No front video camera available")
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Create the video data output
        //        let videoOutput = AVCaptureVideoDataOutput()
        videoOutputFace.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutputFace.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        // 加入脸部识别
        //            // Add the video output to the capture session
        session.addOutput(videoOutputFace)
        
        let videoConnection = videoOutputFace.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        //        session.startRunning()
    }
}

// MARK: UI
extension TestViedo {
    func setUpPreview() {
        do{
            
            let videoInput1 = try! AVCaptureDeviceInput(device: self.videoDevice!)
            self.captureSession.addInput(videoInput1)
            //            let audioInput1 = try! AVCaptureDeviceInput(device: self.audioDevice!)
            //            self.captureSession.addInput(audioInput1);
            
            //            videoOutputFace
            //添加视频捕获输出
            self.captureSession.addOutput(self.fileOutput)
            printLog(captureSession)

            //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
            let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            //预览窗口是正方形，在屏幕居中（显示的也是摄像头拍摄的中心区域）
            videoLayer.frame = CGRect(x:self.view.bounds.height/4,
                                      y:self.view.bounds.height/4,
                                      width: self.view.bounds.width/2,
                                      height: self.view.bounds.height/2)
            videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.view.layer.addSublayer(videoLayer)
            
            //启动session会话
            setUpButton()
//            self.captureSession.startRunning()
            
        } catch {
            
            // エラー処理
            printErrorLog(2)
        }
    }
    
    func setUpButton() {
        recordButton=UIButton(frame:CGRect(x:0,y:0,width:120,height:50))
        recordButton.backgroundColor = UIColor.gray
        recordButton.layer.masksToBounds = true
        recordButton.setTitle("録画開始", for:UIControl.State.normal)
        recordButton.layer.cornerRadius = 20.0
        recordButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        recordButton.addTarget(self, action: #selector(onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
        printLog(recordButton)
        
    }
    
}

//共通
extension TestViedo {
    //录像回看
    func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: outputURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

extension TestViedo {
    func otherVC() {
        //        let a = FaceDetectionViewController.init(nibName: "main", bundle: Bundle.init(identifier: "FaceDetectionViewController"))
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        var a = sb.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
        a.configureCaptureSession()
        //        a.session.startRunning()
        
    }
}
