//
//  DateExtension.swift
//  iAntique
//
//  Created by 文伍 on 2024/6/4.
//

import Foundation

extension Date {
    
    /// 获取当前时间戳
    /// - Returns: 当前时间戳
    static func nowTimeStamp() -> Int {
        let nowDate = Date.init()
        //10位数时间戳
        let interval = Int(nowDate.timeIntervalSince1970)
        return interval
    }
    
    /// 获取当前时间字符串
    /// - Returns: 当前时间戳
    static func nowTimeString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let nowDate = Date.init()
        return dateformatter.string(from: nowDate)
    }
    
    /// 时间戳转换时间字符串
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    static func converToString(timeStamp: Int, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval.init(timeStamp))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: date)
    }
    
    
    /// 日期转Date
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: Date
    static func converToDate(timeString: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = dateformatter.date(from: timeString) ?? Date()
        return date
    }
    
    /// 日期转时间戳
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间戳
    static func converToTimeStamp(timeString: String, dateFormat: String) -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = self.converToDate(timeString: timeString, dateFormat: dateFormat)
        return Int(date.timeIntervalSince1970)
    }
    
    
    /// 时间戳转换时间date
    /// - Parameters:
    ///   - timeStamp: 时间戳
    /// - Returns: date
    static func getDateWith(timeStamp: Int) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval.init(timeStamp))
        return date
    }
    
    static func getTimeStamp(with date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    /// 获取（年，月，日，时，分，秒）
    /// - Returns: （年，月，日，时，分，秒）
    func getTime() -> (String, String, String, String, String, String) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        let y = dateformatter.string(from: self)
        dateformatter.dateFormat = "MM"
        let mo = dateformatter.string(from: self)
        dateformatter.dateFormat = "dd"
        let d = dateformatter.string(from: self)
        dateformatter.dateFormat = "HH"
        let h = dateformatter.string(from: self)
        dateformatter.dateFormat = "mm"
        let m = dateformatter.string(from: self)
        dateformatter.dateFormat = "ss"
        let s = dateformatter.string(from: self)
        
        return (y, mo, d, h, m, s)
    }
    
    
    /// 获取时间字符串
    /// - Parameter dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    func getStringTime(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: self)
    }
    
}
