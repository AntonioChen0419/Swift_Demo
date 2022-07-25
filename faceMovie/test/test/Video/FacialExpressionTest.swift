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

class FacialExpressionTest: UIViewController {
    
    ///录像
    // 录像按钮
    @IBOutlet var recordButton: UIButton!
    // 正在录音
    var isRecording = false
    //最大允许的录制时间（秒）
    let videoTimeCount = TimeInterval(15)
    let totalSeconds: Float64 = Float64( 15 * 2.00 + 3.0)
    //每秒帧数
    var framesPerSecond:Int32 = 30
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
    //    let movieDevice = AVCaptureDevice.default(for: .audio
    //音频输入设备
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    //保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    var assetURLs = [String]()
    //单独录像片段的index索引
    var appendix: Int32 = 1
    
    @IBOutlet var testImage: UIImageView!
    
    ///脸部识别
    let faceSession = AVCaptureSession()
    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    var faceViewHidden = false
    var sequenceHandler = VNSequenceRequestHandler()
    var videoOutputFace = AVCaptureVideoDataOutput()
    var videoLayer = AVCaptureVideoPreviewLayer()
    var faceCount = 0{
        willSet{
            printLog(newValue)
            DispatchQueue.main.sync { [weak self] in
                if newValue <= 5 {
                    self!.recordButton.backgroundColor = whiteColorE4E4E4.uicolor()
                    self!.recordButton.isUserInteractionEnabled = false
                    self!.testImage.image = UIImage.init(named: "QRCode_gray_ScanBox")
                } else {
                    self!.recordButton.backgroundColor = blueColor365CDC.uicolor()
                    self!.recordButton.isUserInteractionEnabled = true
                    self!.testImage.image = UIImage.init(named: "QRCode_ScanBox")
                }
            }
            
            
        }
        didSet{
            
        }
    }
    
    var faceType: FaceType = .videoFirst
    var videoTimeFirst3S: Timer?
    var videoTimeSecond15S: Timer?
    var videoTimeThird15S: Timer?
    var videoTimeCountDown: Timer?
    var countDownNumber: Int = 0
    
    var noteLabelText = "真顔を維持してください。"
    private let blueColor365CDC = "365CDC"
    private let grayColor999999 = "999999"
    public let whiteColorE4E4E4 = "E4E4E4"
    private let makeVedioButtonTitle = "撮影する"
    private let shootingButtonTitle = "撮影中"
    
    
    @IBOutlet var countDownNumberLabel: UILabel!
    
    @IBOutlet var videoLayerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceType = .videoFirst
        // 设置预览画面
        setUpPreview()
        setupFace()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: 录像 delegate
extension FacialExpressionTest: AVCaptureFileOutputRecordingDelegate {
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didStartRecordingTo fileURL: URL,
                    from connections: [AVCaptureConnection]) {
        printLog("录像启动的代理方法")
    }
    
    func fileOutput(_ output:AVCaptureFileOutput, didFinishRecordingTo outputFileURL:URL, from connections: [AVCaptureConnection], error:Error?) {
        printLog(output)
        
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        videoTimeCountDown?.invalidate()
        
        printGreenLog("视频拍摄结束正在处理文件")
        //        changeFaceTypeStatus()
        //        if faceType == .finshed{
        //            saveVideoToDocument(outputFileURL: outputFileURL)
        //        }
        saveVideoToDocument(outputFileURL: outputFileURL)
        faceType = .finshed
        
        return
        if faceType == .videoFirst {
            faceType = .videoSecond
            printGreenLog("视频拍摄结束正在处理文件--- 变更 factype = second 🔵")
            
            videoSecond15S()
            startRecord()
            
        } else if faceType == .videoSecond {
            faceType = .videoThird
            printGreenLog("视频拍摄结束正在处理文件--- 变更 factype = third 🔵")
            
            videoThird15S()
            startRecord()
        } else if faceType == .videoThird {
            faceType = .finshed
            printGreenLog("视频拍摄结束正在处理文件--- 变更 factype = finshed 🔵")
            
            saveVideoToDocument(outputFileURL: outputFileURL)
            countDownNumberLabel.isHidden = true
            
        }else if faceType == .finshed {
        } else {
            printErrorLog("face type is null")
            
        }
        //        saveVideoToDocument(outputFileURL: outputFileURL)
    }
    
    
    
}

// MARK: 人脸 delegate
extension FacialExpressionTest: AVCaptureVideoDataOutputSampleBufferDelegate {
    // 人脸识别过程
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            //未识别到 - 失败
            printErrorLog(sampleBuffer)
            return
        }
        print("🟣")
        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
        do {
            try sequenceHandler.perform(
                [detectFaceRequest],
                on: imageBuffer,
                orientation: .leftMirrored)
            printLog(#function)
            
        } catch {
            printErrorLog(error.localizedDescription)
            return
        }
    }
    
    //  初始化人脸识别判断
    func setupFace() {
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
            return printErrorLog("No back video camera available")
        }
        do {
            let cameraFaceInput = try AVCaptureDeviceInput(device: camera)
            faceSession.addInput(cameraFaceInput)
            
        } catch {
            printErrorLog(error.localizedDescription)
            return
        }
        videoOutputFace.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutputFace.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        // 加入脸部识别
        //            // Add the video output to the capture session
        faceSession.addOutput(videoOutputFace)
        
        let videoConnection = videoOutputFace.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        //        session.startRunning()
        videoLayer = AVCaptureVideoPreviewLayer(session: faceSession)
        videoLayer.videoGravity = .resizeAspectFill
        videoLayer.bounds = videoLayerImageView.bounds
        videoLayer.frame = CGRect(x:0,
                                  y:0,
                                  width: videoLayerImageView.bounds.width,
                                  height: videoLayerImageView.bounds.height)
        
        videoLayerImageView.layer.insertSublayer(videoLayer, at: 0)
        videoLayerImageView.backgroundColor = .yellow
        faceSession.startRunning()
        
    }
    
    // 循化判断face
    func detectedFace(request: VNRequest, error: Error?) {
        // 1
        guard
            let results = request.results as? [VNFaceObservation],
            let _ = results.first
        else {
            print("🔴 = " + #function)
            faceCount = 0
            return
        }
        faceCount += 1
    }
    
}

// MARK: UI
extension FacialExpressionTest {
    // 初始化镜头摄影
    func setUpPreview() {
        let videoInputForMovie = try! AVCaptureDeviceInput(device: self.videoDevice!)
        //            videoInput1.device.position = .front
        self.captureSession.sessionPreset = .hd1280x720
        self.captureSession.addInput(videoInputForMovie)
        //            let audioInput1 = try! AVCaptureDeviceInput(device: self.audioDevice!)
        //            self.captureSession.addInput(audioInput1);
        
        let connection = fileOutput.connection(with: .video)
        if ((connection?.isVideoStabilizationSupported) != nil) {
            connection?.preferredVideoStabilizationMode = .auto
        }
        if fileOutput.availableVideoCodecTypes.contains(.h264) {
            fileOutput.setOutputSettings(["AVVideoCodecKey": AVVideoCodecType.h264], for: connection!)
        }
        //        if let connection = fileOutput.connection(with: .video) {
        //          // 设置是否镜像，默认是 false
        //          connection.isVideoMirrored = true
        //        }
        //添加视频捕获输出
        self.captureSession.addOutput(self.fileOutput)
        printLog(captureSession)
        
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.bounds = videoLayerImageView.bounds
        videoLayer.frame = CGRect(x:0,
                                  y:0,
                                  width: videoLayerImageView.bounds.width,
                                  height: videoLayerImageView.bounds.height)
        
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //            self.view.layer.addSublayer(videoLayer)
        videoLayerImageView.layer.insertSublayer(videoLayer, at: 0)
        //        videoLayerImageView.center = self.view.center
        setUpButton()
        
        
        //  设置视频清晰度
        //                  captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
    }
    
    // 摄影按钮
    func setUpButton() {
        recordButton.backgroundColor = blueColor365CDC.uicolor()
        
        recordButton.layer.masksToBounds = true
        recordButton.setTitle(makeVedioButtonTitle, for:UIControl.State.normal)
        recordButton.setTitleColor(.white, for: .normal)
        
        recordButton.setTitle(makeVedioButtonTitle, for:UIControl.State.disabled)
        recordButton.setTitleColor(grayColor999999.uicolor(), for: .disabled)
        
        recordButton.setTitle(makeVedioButtonTitle, for:UIControl.State.highlighted)
        recordButton.setTitleColor(.white, for: .highlighted)
        
        recordButton.layer.cornerRadius = 15.0
        recordButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        recordButton.addTarget(self, action: #selector(onClickRecordButton(sender:)), for: .touchUpInside)
        
    }
    
    // 小段视频开始录 UI处理
    func saveVideoByfile() {
        saveShortVideoAndConfiguration()
        isRecording=true
        recordButton.setTitle(shootingButtonTitle, for: .normal)
        recordButton.setTitleColor(grayColor999999.uicolor(), for: .normal)
        
    }
    
    // 小段视频录完 UI处理
    func finshVideo() {
        isRecording=false
        if faceType == .finshed{
            recordButton.setTitle(makeVedioButtonTitle, for: .normal)
            recordButton.setTitleColor(.white, for: .normal)
            recordButton.backgroundColor = blueColor365CDC.uicolor()
        }
    }
}

//MARK: 交互
extension FacialExpressionTest {
    // MARK: 摄影按钮点击事件
    @objc func onClickRecordButton(sender: UIButton) {
        faceOver()
        startRecord()
        videoFirst15S()
        //        faceSession.stopRunning()
        //        printLog(isRecording)
        
        if !isRecording {
            //            self.captureSession.startRunning()
            //            printLog(isRecording)
            //            saveVideoByfile()
            //            testImage.isHidden = true
            //            self.captureSession.startRunning()
            startRecord()
            
        } else {
            // 録画終了
            //            fileOutput.stopRecording()
            //            finshVideo()
            //                        finshRecord()
        }
    }
    
    func faceOver() {
        faceSession.stopRunning()
        printLog(isRecording)
    }
    
    func startRecord() {
        printGreenLog("摄影开始 🟡")
        if faceType == .finshed {
            return
        }
        self.captureSession.startRunning()
        printLog(isRecording)
        saveVideoByfile()
        testImage.isHidden = true
        countDown()
    }
    
    func finshRecord() {
        printGreenLog("摄影终了 🟣")
        if faceType == .finshed {
            countDownNumberLabel.isHidden = true
        }
        // 録画終了
        fileOutput.stopRecording()
        finshVideo()
    }
}

//MARK: 业务处理
extension FacialExpressionTest {
    //录像回看 方便录像查看,提交时删除
    func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: outputURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //保存到指定目录 格式video mp4
    func saveShortVideoAndConfiguration() {
        DispatchQueue.main.async { [weak self] in
            self?.recordButton.backgroundColor = self?.whiteColorE4E4E4.uicolor()
            
        }
        // 録画開始
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String? = "\(documentsDirectory)/\(getFaceTypeAddress()).mp4"
        let fileURL :NSURL = NSURL(fileURLWithPath: filePath!)
        
        fileOutput.startRecording(to: fileURL as URL, recordingDelegate:self)
    }
    
    // 将录制好的录像保存到照片库中
    func XTestSaveVideoToPHPhotoLibrary(_ outputFileURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            //将视频转成Data
            //            let data = NSData(contentsOf: outputFileURL)
            //            print(data)
            printLog(outputFileURL)
            
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            
        })
    }
    
    func saveVideoToDocument(outputFileURL: URL) {
        mergeVideos()
        //        getVedioByself()
    }
    
    //合并视频片段
    func mergeVideos() {
        let duration = totalSeconds
        
        let composition = AVMutableComposition()
        //合并视频
        let firstTrack = composition.addMutableTrack(
            withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        //        let audioTrack = composition.addMutableTrack(
        //            withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
        
        var insertTime: CMTime = CMTime.zero
        for asset in videoAssets {
            do {
                try firstTrack?.insertTimeRange(
                    CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                    of: asset.tracks(withMediaType: AVMediaType.video)[0] ,
                    at: insertTime)
            } catch _ {
                printErrorLog("合并失败")
            }
            //            do {
            //                try audioTrack?.insertTimeRange(
            //                    CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
            //                    of: asset.tracks(withMediaType: AVMediaType.audio)[0] ,
            //                    at: insertTime)
            //            } catch _ {
            //            }
            
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        
        //旋转视频图像，防止90度颠倒
        firstTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        //定义最终生成的视频尺寸（矩形的）
        printLog("视频原始尺寸：")
        printLog(firstTrack!.naturalSize)
        let renderSize = CGSize(width: firstTrack!.naturalSize.width,
                                height:firstTrack!.naturalSize.height)
        //        let renderSize = CGSize(width: 1280,
        //                                height: 960)
        
        printLog("最终渲染尺寸：")
        printLog(renderSize)
        //通过AVMutableVideoComposition实现视频的裁剪(矩形，截取正中心区域视频)
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: framesPerSecond)
        videoComposition.renderSize = renderSize
        
        printLog("截取正中心区域视频")
        printLog(videoComposition.renderSize)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(
            start: CMTime.zero,
            duration: CMTimeMakeWithSeconds(Float64(duration),
                                            preferredTimescale: framesPerSecond))
        
        //视频缩放和旋转
        let transformer: AVMutableVideoCompositionLayerInstruction =
        AVMutableVideoCompositionLayerInstruction(assetTrack: firstTrack!)
        
        printLog(firstTrack?.naturalSize.width as Any)
        //                let t1 = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: (firstTrack!.naturalSize.width ) * 0.20, ty: -(firstTrack!.naturalSize.width - firstTrack!.naturalSize.height)/2)
        // 个人感觉 tx和ty 跟裁剪有关;    a和d 是控制镜面翻转
        //        let t1 = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: self.view.frame.size.width * 0.25, ty: self.view.frame.size.height * -0.1)
        
        //        t1.scaledBy(x: 0, y: 10)
        printLog("firstTrack --- ")
        printLog(firstTrack?.nominalFrameRate)
        printLog(firstTrack?.naturalSize)
        
        //        let t1 = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //let t1 = CGAffineTransform(translationX: firstTrack!.naturalSize.height,
        //    y: -(firstTrack!.naturalSize.width - firstTrack!.naturalSize.height)/2)
        
        //        var t1: CGAffineTransform = CGAffineTransform(a: -1, b: 0, c: 0, d: 1,tx: firstTrack!.naturalSize.height, ty: 0)
        //        var t2: CGAffineTransform = t1.rotated(by: CGFloat(M_PI_2)/2)
        //(0 0; 1024 1366)
        let t1 = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 1024 * 0.2745, ty: self.view.frame.size.height * -0.1 )
        
        let t2 = t1.rotated(by: CGFloat.pi/2)
        let finalTransform: CGAffineTransform = t2
        //        transformer.setTransform(finalTransform.inverted(), at: CMTime.zero)
        
        transformer.setTransform(finalTransform, at: CMTime.zero)
        
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //获取合并后的视频路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mp4"
        printLog("合并后的视频路径： \(destinationPath)")
        
        let videoPath = URL(fileURLWithPath: destinationPath as String)
        let exporter = AVAssetExportSession(asset: composition,
                                            presetName:AVAssetExportPresetHighestQuality)!
        //AVFileTypeQuickTimeMovie
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mp4
        exporter.videoComposition = videoComposition //设置videoComposition
        exporter.shouldOptimizeForNetworkUse = true
        exporter.timeRange = CMTimeRangeMake(
            start: CMTime.zero,
            duration: CMTimeMakeWithSeconds(Float64(33.0), preferredTimescale: framesPerSecond))
        exporter.exportAsynchronously(completionHandler: {
            switch exporter.status {
            case  .failed:
                if let e = exporter.error {
                    print("export failed \(e)")
                }
            case .cancelled:
                print("export cancelled \(String(describing: exporter.error))")
            default:
                //将合并后的视频保存到相册
                self.exportDidFinish(session: exporter)
            }
            
        })
    }
    
    //将合并后的视频保存到相册
    func exportDidFinish(session: AVAssetExportSession) {
        print("视频合并完成！")
        let outputURL = session.outputURL!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.delayExecution(url: outputURL)
        }
    }
    func delayExecution(url: URL) {
        self.reviewRecord(outputURL: url)
    }
}

