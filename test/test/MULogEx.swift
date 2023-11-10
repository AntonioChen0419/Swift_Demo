//
//  MULogEx.swift
//  MUTB
//
//  Created by cyanboo on 2022/7/27.
//

import Foundation


///一般的な印刷
public func printLog(_ msg: Any,
                     file: NSString = #file,
                     line: Int = #line,
                     fn: String = #function) {
    
    let prefix = settingPrefix(msg: msg,  file: file, line: line, fn: fn, color: "🟢")
    printLogs(prefixs: prefix)
}

///error
public func printErrorLog(_ msg: Any,
                          file: NSString = #file,
                          line: Int = #line,
                          fn: String = #function) {
    
    let prefix = settingPrefix(msg: msg,  file: file, line: line, fn: fn, color: "🔴🔴🔴")
    printLogs(prefixs: prefix)
}
///debug
public func printGreenLog(_ msg: Any,
                          file: NSString = #file,
                          line: Int = #line,
                          fn: String = #function) {
    
    let prefix = settingPrefix(msg: msg,  file: file, line: line, fn: fn, color: "🟢🟢🟢")
    printLogs(prefixs: prefix)
}
///debug キーワードとデータ
public func printYellowLog(_ msg: Any,
                           file: NSString = #file,
                           line: Int = #line,
                           fn: String = #function) {
    
    let prefix = settingPrefix(msg: msg,  file: file, line: line, fn: fn, color: "🟡🟡🟡")
    printLogs(prefixs: prefix)
}
///debug
public func printWhiteLog(_ msg: Any,
                          file: NSString = #file,
                          line: Int = #line,
                          fn: String = #function) {
    
    let prefix = settingPrefix(msg: msg,  file: file, line: line, fn: fn, color: "⚪️⚪️⚪️")
    printLogs(prefixs: prefix)
}

///debug
public func printBlueLog(_ msg: Any,
                         file: NSString = #file,
                         line: Int = #line,
                         fn: String = #function) {
    let prefix = settingPrefix(msg: msg, file: file, line: line, fn: fn, color: "🔵🔵🔵")
    printLogs(prefixs: prefix)
}

///debug
public func printPurpleLog(_ msg: Any,
                           file: NSString = #file,
                           line: Int = #line,
                           fn: String = #function) {
    let prefix = settingPrefix(msg: msg, file: file, line: line, fn: fn, color: "🟣🟣🟣")
    printLogs(prefixs: prefix)
    
}

private func settingPrefix(msg: Any,
                           file: NSString = #file,
                           line: Int = #line,
                           fn: String = #function,
                           color: String) ->String {
    return "\(color)  \(getLogDate())\n\(msg)\n*** \(file.lastPathComponent) \(fn) [第\(line)行] \n";
}
//断点用
public func printDefaultLog() {
    
    
}

private func printLogs(prefixs: String) {
#if DEBUG
    
    print(prefixs)
#else

#endif
    
}

/// log时间
/// - Returns: 返回log时间
private func getLogDate(_ format: String = "YYYY-MM-dd HH:mm:ss +SSSS") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss +SSSS"
    formatter.locale = Locale.init(identifier: "ja_JP")
    formatter.timeZone = TimeZone.init(identifier: "UTC")
    let zone = TimeZone.current
    let nowDate1 = Date()
    let interval1 = zone.secondsFromGMT(for: nowDate1)
    let nowTime1 = nowDate1.addingTimeInterval(TimeInterval(interval1))
    let nowDateString = formatter.string(from: nowTime1)
    return nowDateString
}
