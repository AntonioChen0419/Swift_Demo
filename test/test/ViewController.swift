//
//  ViewController.swift
//  test
//
//  Created by cyanboo on 2022/2/22.
//

import UIKit
import CoreBluetooth

struct Chen: MUResponse {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "name"

    }

}

protocol MUResponse: Codable {

    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? { get }

    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? { get }
}

extension MUResponse {

    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? {
        return nil
    }

    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return nil
    }
}


class ViewController: UIViewController {
    var mangers: CBPeripheralManager?
    // save image
    let coverPath = NSHomeDirectory() + "/Documents/CoverPage/"
    let saveCoverImageKey = "cardUpImageName"
    typealias Response = Chen


    override func viewDidLoad() {
        super.viewDidLoad()
        let bools = Date.isSurveyDateAndTodayIsSameDay(surveyDate: "2023-10-26")
        printLog(bools)
//        englistMath()
//        emailCheck()
//        let strList = "1111211122223".components(separatedBy: "111")
//        let strList = "111211122223".contains("4")
//        printLog( strList.count > 1)
//        printLog( strList)

//        printLog(getSONFile(forName: "", jsonModelType: Chen.self))

//        let a: Double = 109.9 + 44.3
//
//        printLog(String(a))


//       let a =  self.stringCellDateTime(string: "2022-11-23T10:45:42.642+09:00")
//        printLog(a)
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

    func stringCellDateTime(string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale.init(identifier: "ja_JP")
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        guard let date = formatter.date(from: string) else {
            assert(false, "convert date by format is failed")
            return "999"
        }
        let formatterYYYYMMDD = DateFormatter()
        formatterYYYYMMDD.dateFormat = "YYYY年MM月dd日 HH:mm:ss"
        formatterYYYYMMDD.locale = Locale.init(identifier: "ja_JP")
        formatterYYYYMMDD.timeZone = TimeZone.init(identifier: "UTC")
        formatterYYYYMMDD.dateStyle = .medium
        formatterYYYYMMDD.timeZone = TimeZone.init(identifier: "Asia/Tokyo")
        let nowDate = formatterYYYYMMDD.string(from: date)

        return "\("updateDay") - \(nowDate)"
    }
    
}

//获取打印的文件名、打印行数、打印函数
public func printLog(_ msg: Any,
                     file: NSString = #file,
                     line: Int = #line,
                     fn: String = #function) {
#if DEBUG
    let prefix = "\(file.lastPathComponent) \(fn) 🟢🟢🟢 [第\(line)行] \(msg)";
    print(prefix)
#endif
}

//获取打印的文件名、打印行数、打印函数
public func printErrorLog(_ msg: Any,
                          file: NSString = #file,
                          line: Int = #line,
                          fn: String = #function) {
#if DEBUG
    let prefix = "\(file.lastPathComponent) \(fn) 🔴🔴🔴 [第\(line)行] \(msg)";
    print(prefix)
#endif
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

extension ViewController {
    //半角英数字
    func englistMath() {
        let bbb = "123asdrds@d232"
        //^[A-Za-z0-9]+$ 或 ^[A-Za-z0-9]{4,40}$
        var str = "^[A-Za-z0-9]+$"

        let result = NSPredicate(format: "SELF MATCHES %@", str)
        if result.evaluate(with: bbb) {
            printLog("ok")
        } else {
            printErrorLog("error")
        }
    }

    //邮箱
    func emailCheck() {
        var email = "123asdrds@cn.slj.com"
//        email = "1lksjf@jlklj.com"
        //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}"
        //TODO: 如果有特殊要求 例如尾缀.com .cn .net  ,或者@后面有ibm 等要求需要详细需求
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

//        let regex = "[A-Z0-9a-z._%+-]+@ibm+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: email)
        if isValid {
            printLog("ok")

            if let subAtString =  email.lastIndex(of: "@") {
                printLog(subAtString)
                let afterAtString = email[email.index(subAtString, offsetBy: 1) ..< email.endIndex]
                printLog(afterAtString)
                let uppercasedString = afterAtString.uppercased()
                let strList = uppercasedString.components(separatedBy: ".")
                if strList.contains(where: { item in
                    return item == "ibm"
                }) {
                    printLog("ibm")
                } else if strList.contains(where: { item in
                    return item == "MUTB"
                }) {
                    printLog("MUTB")
                } else {
                    printLog("弹窗")
                }
            } else {
                /// 不允许弹窗
            }

        } else {
            ///不允许弹窗
            printErrorLog("error")
        }
    }
}

extension ViewController {

    func test123<T>(a: T.Type) {
        printLog(a)
    }

    func getSONFile<T:Codable>(forName name: String, jsonModelType: T.Type) -> Any?{
        printLog(T.self)

//        do {
//           if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
//           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//              if let model = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? jsonModelType {
//
//                  return model
//              } else {
//                 print("Given JSON is not a valid dictionary object.")
//                  return nil
//              }
//           }
//        } catch {
//           print(error)
//            return nil
//        }

        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json")
           {
            do {
                if let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8) {
                    let model = try JSONDecoder().decode(T.self, from: jsonData)
                    return model
                }
            } catch {
                return nil
            }

        }
        return nil


    }
}

extension Date{
    static func isSurveyDateAndTodayIsSameDay(surveyDate: String) -> Bool {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
//        formatter.timeZone = TimeZone.init(identifier: "Asia/Tokyo")
//        guard let date = formatter.date(from: surveyDate) else {
//            assert(false, "convert date by format is failed")
//            return false
//        }
        let formatterYYYYMMDD = DateFormatter()
        formatterYYYYMMDD.dateFormat = "YYYY-MM-dd"
        formatterYYYYMMDD.timeZone = TimeZone.init(identifier: "Asia/Tokyo")
        let nowDate = formatterYYYYMMDD.string(from: Date())

        return nowDate == surveyDate
    }
}
