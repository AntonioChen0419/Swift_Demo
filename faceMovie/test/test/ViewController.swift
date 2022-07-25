//
//  ViewController.swift
//  test
//
//  Created by cyanboo on 2022/2/22.
//

import UIKit
import CoreBluetooth
import AVFoundation
import Photos

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    var mangers: CBPeripheralManager?
    // save image
    let coverPath = NSHomeDirectory() + "/Documents/CoverPage/"
    let saveCoverImageKey = "cardUpImageName"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
            printErrorLog("No back video camera available")
            return
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
//            faceSession.addInput(cameraInput)
            
        } catch {
            printErrorLog(error.localizedDescription)
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL.init(fileURLWithPath: ""))
//            printLog(outputURL)
        }) { isSuccess, error in
            
        }
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
                    [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera, .builtInDualWideCamera, .builtInTripleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera],
                mediaType: .video, position: .back)

        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        devices.forEach({
           print($0.deviceType)
        })
        
//        print("123")
//        let viewC = CNCircleProgressView.init(frame: CGRect.init(x: 100, y: 50, width: 100, height: 100))
////        viewC.frame
//        viewC.circleWithProgress(progress: 0.9,title: "左目", andIsAnimate: true)
////        self.navigationController?.pushViewController(viewC, animated: true)
////        viewC.frame = CGRect.init(x: 100, y: 50, width: 200, height: 200)
////        self.view.backgroundColor = UIColor.gray
//        self.view.addSubview(viewC)
//        self.view.backgroundColor = UIColor.gray
        
        
        // Do any additional setup after loading the view.
//        mangers = CBPeripheralManager.init(delegate: self, queue: DispatchQueue.global())
//        mangers?.delegate = self
//        self.view.backgroundColor = .blue
//        if mangers != nil {
//            
//        }
//        
//        let a = 100
//        let letObject: Int = {
//            //            statements
//            return a + (Int(arc4random())%3)
//        }()
//        
//        let bbb = addStr { it, ia in
//            
//            return it + ia + "1"
//        }// 这种就是尾随闭包的写法
//        print(bbb)
    }
    func addStr(closure:(_ a1:String,_ b1:String)->String)->String{
        return "closure()"
    }
    
}

//获取打印的文件名、打印行数、打印函数
public func printLog(_ msg: Any,
                     file: NSString = #file,
                     line: Int = #line,
                     fn: String = #function) {
#if DEBUG
    let prefix = "\(getLogDate()) \(msg) \(file.lastPathComponent)  \(fn) [第\(line)行]";
    print(prefix)
#endif
}

//获取打印的文件名、打印行数、打印函数
public func printErrorLog(_ msg: Any,
                          file: NSString = #file,
                          line: Int = #line,
                          fn: String = #function) {
#if DEBUG
    let prefix = "\(getLogDate())🔴🔴🔴\(msg) \(file.lastPathComponent)  \(fn) [第\(line)行] \n ";
    print(prefix)
#endif
}

public func printGreenLog(_ msg: Any,
                     file: NSString = #file,
                     line: Int = #line,
                     fn: String = #function) {
#if DEBUG
    let prefix = "\(getLogDate())🟢🟢🟢 \(msg) \n\(file.lastPathComponent)  \(fn) [第\(line)行] ";
    print(prefix)
//    NSLog(prefix)
#endif
}

func getLogDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.timeZone = TimeZone.init(identifier: "Asia/Beijing")
    let nowDate1 = Date()
    formatter.string(from: nowDate1)
    return formatter.string(from: nowDate1)
}

extension ViewController: CBPeripheralManagerDelegate{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
}


// MARK: save or remove image
extension ViewController {
    
    // TODO: 需要改成视频格式
    /// save image
    func saveImageAddressToUserDefaults(imageName: String) {
        var imageNameAddressDic = getUserDefaultCoverDictory()
        var dic = [String: String]()
        if imageNameAddressDic != nil {
            imageNameAddressDic?.updateValue(imageName, forKey: "video name")
            dic = imageNameAddressDic!
        } else {
            dic = ["video name": imageName]
        }
        setUserDefaultCoverDictory(dic: dic)
    }

    // TODO: 需要改成视频格式
    private func saveImageFileToDocuments(currentImage: UIImage, persent: CGFloat, imageName: String) {
        //png
        guard let imagePNGData = currentImage.pngData() as NSData? else { return }
        let fullPath = coverPath.appending(imageName) + ".png"
        ViewController.existFullPathDirectory(coverFolderFullPath: coverPath)
        let imageNameAddressDic = getUserDefaultCoverDictory()
        if let imageNames = imageNameAddressDic?["video name"] {
            removeCoverImage(imageName: imageNames)
        }
        do {
            try imagePNGData.write(toFile: fullPath, options: NSData.WritingOptions.atomic)
            saveImageAddressToUserDefaults(imageName: imageName + ".png")
        } catch {
            //jpeg
            saveImageTypeOfJpeg(currentImage: currentImage, persent: persent, imageName: imageName)
        }
    }

    private func saveImageTypeOfJpeg(currentImage: UIImage, persent: CGFloat, imageName: String) {
        if let imageData = currentImage.jpegData(compressionQuality: persent) as NSData? {
            let fullPath = coverPath.appending(imageName) + ".jpeg"
            saveImageAddressToUserDefaults(imageName: imageName + ".jpeg")
            imageData.write(toFile: fullPath, atomically: true)
        }
    }

    /// remove image
    private func removeCoverImage(imageName: String) {
        let fullPath = coverPath + imageName
        ViewController.removeFileByPath(path: fullPath)
        removeCoverUserDefaults(accountNumber: "1234")
    }

    private func removeCoverUserDefaults(accountNumber: String) {
        var imageNameAddressDic = getUserDefaultCoverDictory()
        if imageNameAddressDic?[accountNumber] != nil {
            imageNameAddressDic?.removeValue(forKey: accountNumber)
            setUserDefaultCoverDictory(dic: imageNameAddressDic!)
        }
    }

    private func getUserDefaultCoverDictory() -> [String: String]? {
        return UserDefaults.standard.value(forKey: saveCoverImageKey) as? [String: String]
    }

    private func setUserDefaultCoverDictory(dic: [String: String]) {
        UserDefaults.standard.set(dic, forKey: saveCoverImageKey)
    }
}

/*
 all file clean (all file delete)
 ///TODO: delete UserDefaults's cover info
 let imageNameAddressDic = UserDefaults.standard.value(forKey: "cardUpImageName") as? NSDictionary

 let accounts = DataManager.shared.accounts()
 let account: Account = accounts.first!
 let accountCardAddress = imageNameAddressDic?.object(forKey: account.accountNumber as String)
 UserDefaults.standard.removeObject(forKey: "cardUpImageName")
 deleteFile(filePath: accountCardAddress as! String)
 */


// MARK: - Cover (cover background image)
extension ViewController {

    static func existFullPathDirectory(coverFolderFullPath: String) {
        existFullPathDirectory(fullPath: coverFolderFullPath)
    }

    private static func existFullPathDirectory(fullPath: String) {
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: fullPath)
        if !exist {
            do {
                try manager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
                assert(true, "Succes to create folder")
            } catch {
                assert(true, "Error to create folder")
            }
        }
    }

    static func removeFileByPath(path: String) {
        removeFile(path: path)
    }

    private static func removeFile(path: String) {
        let fileManager = FileManager.default
        let fullPath = path
        do {
            try fileManager.removeItem(atPath: fullPath)
        } catch {
            assert(true, "Image remove error, cover image remove failed")
        }
    }
    

}
