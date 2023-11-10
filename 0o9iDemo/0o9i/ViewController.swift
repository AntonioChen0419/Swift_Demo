//
//  ViewController.swift
//  0o9i
//
//  Created by cyanboo on 2022/9/8.
//

import UIKit
import Foundation

enum JobKindType: String, Codable {
    case voice = "voice"
    case smile = "smile"
    case inference = "inference"
    case study = "study"
}

enum JobStatusType: String, Codable {
    case running = "running"
    case success = "success"
    case failure = "failure"
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var testTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var a = 1
        print("")
        print(Date.stringCellDate(string: "2023-01-01T23:59:59.968+08:00"))
        let cellList = DetectionStatusCellModel().getCellDefaultModel()
        cellList.map { model in
            print(model.errorMessage)
        }
        print("=======================")
        let _ =  cellList.forEach { model in
              if model.status == .failure {
                  model.errorMessage = "requestErrorMessage"
              }
          }
        cellList.map { model in
            print(model.errorMessage)
        }
//        print(cellList)
        testTF.delegate = self

    }

    @IBAction func pushNext(_ sender: Any) {
        let personalViewController = self.GET_SB(sbName: "Main").instantiateViewController(withIdentifier: "FirstViewController")
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
    func GET_SB (sbName : String) -> UIStoryboard {
        return UIStoryboard(name: sbName, bundle: Bundle.main)
    }

}

extension ViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let a = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0 ))
        let textLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if string == "" {
            return true
        }
        if string.lengthOfBytes(using: .utf8) > 1 {
            return false
        }
        if textField == testTF {
            if textLength > 5 || !checkText(text: string) {
                return false
            }
            print(textField.text)
            print(string)

        }
        print(testTF.text)
        return true
    }

    func checkText(text: String) -> Bool{

        
        let bbb = "123asdrds@d232"
        //^[A-Za-z0-9]+$ 或 ^[A-Za-z0-9]{4,40}$
        var str = "^[A-Za-z0-9]+$"

        let result = NSPredicate(format: "SELF MATCHES %@", str)
//        printLog(text)
//        printLog(result.evaluate(with: text))
        return result.evaluate(with: text)

    }

    func convertHalfFromString(fullStr: String) -> String{

//        fullStr.replacingCharacters(in: "。", with: ".")
        let srcStr = fullStr.replacingOccurrences(of: "。", with: ".")
        let cfstr = NSMutableString(string: String(srcStr)) as CFMutableString
        var range = CFRangeMake(0,CFStringGetLength(cfstr))
        CFStringTransform(cfstr,&range,kCFStringTransformFullwidthHalfwidth,Bool(truncating: 0))
//        CFStringTransform(cfstr,&range,kcfStringTransformFullwidthHalfwidth,Bool(0))
        return cfstr as String
    }
}



// cell date
extension Date{
    static func stringCellDate(string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale.init(identifier: "ja_JP")
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        guard let date = formatter.date(from: string) else {
            assert(false, "convert date by format is failed")
            return "999"
        }
        //        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        //        let dates = date.addingTimeInterval(secondFromGMT)
        let formatterYYYMMDD = DateFormatter()
        formatterYYYMMDD.dateFormat = "YYYY年MM月dd日"
        formatterYYYMMDD.locale = Locale.init(identifier: "ja_JP")
        formatterYYYMMDD.timeZone = TimeZone.init(identifier: "UTC")
        let nowDate = formatterYYYMMDD.string(from: date)
        
        return nowDate
    }
}
class DetectionStatusCellModel: NSObject {
    var title: String = ""
    var icon: String = "AI icon"
    var message: String = ""
    var dateTime: String = ""
    var resultIcon: String = ""
    var errorMessage: String = ""
    var errorTitle: String = ""
    var buttonStatus: Bool = false
    var id: Int = 0
    var surveyId: Int = 0
    var kind: JobKindType = .inference
    var status: JobStatusType = .failure
    var messageId: Int = 0
    var createdAt: String = ""
    var updatedAt: String = ""
    var jobListRetry: Int = 0
    var lastAnswerRetry: Int = 0

    var jobErrorMessage: String = ""
    
    func getCellDefaultModel() -> [DetectionStatusCellModel]{
        let smileModel = DetectionStatusCellModel.init()
        smileModel.title = "表情撮影"
        smileModel.dateTime = "2023年03月29日"
        smileModel.icon = "Smiley face icon"
        smileModel.status = .running
        smileModel.resultIcon = "running icon"
        smileModel.message = "表情撮影の解析中です。少々お待ちください"
        smileModel.errorMessage = "123"
        let voiceeModel = DetectionStatusCellModel.init()
        voiceeModel.title = "AIとの会話"
        voiceeModel.dateTime = "2023年03月29日"
        voiceeModel.icon = "AI icon"
        voiceeModel.status = .failure
        voiceeModel.resultIcon = "running icon"
        voiceeModel.message = "会話の解析中です。少々お待ちください"
        voiceeModel.errorMessage = "999"
        return [smileModel,voiceeModel]
        //        smileModel.dateTime = "2023年03月29日"
        //        smileModel.dateTime = "2023年03月29日"
        //        smileModel.dateTime = "2023年03月29日"
        
        /* cell.createdAt = job.createdAt
         cell.updatedAt = job.updatedAt
         cell.dateTime = job.updatedAt //TODO: 转换格式
         cell.errorMessage = ""
         cell.icon = job.kind == .smile ? "Smiley face icon" : "AI icon"
         cell.title = job.kind == .smile ? "表情撮影" : "AIとの会話"
         cell.status = job.status
         cell.retry = job.retry
         cell.messageId = job.messageId
         cell.surveyId = job.surveyId
         cell.id = job.id
         if job.status == .failure {
         cell.resultIcon = "error icon"
         } else if job.status == .success {
         cell.resultIcon = "Success icon"
         } else {
         cell.resultIcon = "running icon"
         }
         if job.status == .success {
         if job.kind == .smile {
         cell.message = "表情撮影の解析に成功しました"
         
         } else {
         cell.message = "会話の解析に成功しました"
         
         }
         } else if job.status == .running {
         if job.kind == .smile {
         cell.message = "表情撮影の解析中です。少々お待ちください"
         
         } else {
         cell.message = "会話の解析中です。少々お待ちください"
         
         }
         
         } else {
         if job.kind == .smile {
         cell.message = "表情撮影の解析に失敗しました"
         //2.1
         cell.buttonStatus = checkLastAnswerAndJobListRetry(lastAnswerList: facialList, cellList: cellList, status: job.kind) //根据逻辑判断
         
         
         } else {
         cell.message = "会話の解析に失敗しました"
         //2.1
         cell.buttonStatus = checkLastAnswerAndJobListRetry(lastAnswerList: conversationList, cellList: cellList, status: job.kind)
         
         }
         
         }
         cell.errorTitle = "失敗原因"
         cell.kind = job.kind
         cell.jobErrorMessage = ""*/
    }
}



extension ViewController {
    //状态栏 背景变色
    func setStatusBarBackgroundColor(color:UIColor) {
        if #available(iOS 13.0, *) {
            let tag = 987654321
            let keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            if let statusBar = keyWindow?.viewWithTag(tag) {
                statusBar.backgroundColor = color
            } else {
                let statusBar = UIView(frame:keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = color
                }
                statusBar.tag = tag
                keyWindow?.addSubview(statusBar)
            }
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = color
            }
        }
    }
    //更改状态栏字体颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setNeedsStatusBarAppearanceUpdate()
//   }

    /*
     有导航栏

     有导航栏的话，状态栏字体颜色时取决与NavigationBar的barStyle属性的，重写preferredStatusBarStyle是不会生效的。
     当navigationBar.barStyle = .default时状态栏的颜色为黑色
     当navigationBar.barStyle = .black时状态栏的颜色为白色
     */
}
