//
//  Foundation.swift
//  BudMall
//
//  Created by 洪陪 on 2024/3/13.
//

import Foundation
import PromiseKit
import UIKit
import Logging

public enum Bud {
    /// iMarket: 返回是否是DEBUG模式
    public static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// 获取国际化文字
    static var keyWindow: UIWindow?

    /// 顶部导航栏高度（包括安全区）
    public static var topBarHeight: CGFloat {
        return safe_top + 44.0
    }

    public static var enableLog: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// iMarket: 屏幕顶部安全距离
    public static var safe_top: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 20 }
        guard let statusBarManager = windowScene.statusBarManager else { return 20 }
        let statusBarHeight = statusBarManager.statusBarFrame.height
        return statusBarHeight
    }

    /// iMarket: 屏幕底部安全距离
    public static var safe_bottom: CGFloat {
        if #available(iOS 11.0, *) {
            return self.keyWindow?.safeAreaInsets.bottom ?? 0.0
        } else {
            return 0
        }
    }

    /// 底部导航栏高度（包括安全区）
    public static var tabBarHeight: CGFloat {
        return safe_bottom + 49.0
    }

    /// app名字
    public static var appName: String {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return "BudChat"
    }

    /// app数字版本
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// app构建版本
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// APP bundleID
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }

    /// Returns both app's version and build numbers "v0.3(7)"
    public static var appVersionAndBuild: String? {
        if appVersion != nil, appBuild != nil {
            if appVersion == appBuild {
                return "v\(appVersion!)"
            } else {
                return "v\(appVersion!)(\(appBuild!))"
            }
        }
        return nil
    }

    /// 设备版本
    public static var deviceVersion: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}

// 快捷获取主队列以及单次执行
public extension DispatchQueue {
    // once
    private static var onceTokens = [String]()
    class func once(_ token: String, block: () -> Void) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        if DispatchQueue.onceTokens.contains(token) {
            return
        }
        DispatchQueue.onceTokens.append(token)
        block()
    }

    // main
    class func main(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}

// json解析
public extension Bud {
    // JSON解析为模型
    static func jsonToModel<T: Codable>(_ modelType: T.Type, _ response: Data) -> T? {
        var modelObject: T?
        do {
            let jsonDecoder = JSONDecoder()
            modelObject = try jsonDecoder.decode(modelType, from: response)
        } catch {
            let logging = Logger(label: "com.decoder.chat")
            logging.error(Logger.Message(stringLiteral: error.localizedDescription))
        }
        return modelObject
    }

    // Data转为JSON dictionary
    static func dataToDictionary(_ data: Data?) -> Any? {
        guard let d = data else { return nil }
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: d)
        } catch {
            let logging = Logger(label: "com.decoder.chat")
            logging.error(Logger.Message(stringLiteral: error.localizedDescription))
        }
        return json
    }

    /// 排序
    /// - Parameter dictionary: 字典
    /// - Returns: 返回排序后并且用&连接起来的字符串
    static func sorted(to dictionary: [String: Any], separator: String = "&") -> String {
        var contents: [String] = []
        // 升序
        let allkey = dictionary.keys.sorted { $0 < $1 }
        for key in allkey {
            let content = convert(to: dictionary[key])
            let result = String(format: "%@=%@", key, content)
            contents.append(result)
        }
        return contents.joined(separator: separator)
    }

    /// Any转字符串
    /// - Parameter params: Any类型
    /// - Returns: 转换后的字符串-如果Any为空则返回 ""
    static func convert(to params: Any?) -> String {
        if let value = params as? String { // 字符串
            return value
        } else if let value = params as? [String: Any] { // 字典
            return convert(to: value)
        } else if let value = params as? [Any] { // 数组
            var list: [String] = []
            for item in value {
                let content = convert(to: item)
                list.append(content)
            }
            return "[\(list.joined(separator: ","))]"
        } else { // 其它类型
            let formatter = NumberFormatter()
            return formatter.string(for: params) ?? ""
        }
    }
}

// 延迟函数
public extension Bud {
    /// iMarket: 延迟执行
    static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }

    /// iMarket: 在x秒后运行函数
    static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
}

// 通过文字计算Label
public extension Bud {
    /// iMarket: 通过文字计算label的宽度（单行文字的情况）
    static func labelWithWidth(text: String, font: UIFont) -> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: 500_000, height: 500_000)
        let attr = [NSAttributedString.Key.font: font]
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attr, context: nil).size
        return strSize.width
    }

    /// iMarket: 通过文字计算label的高度（宽度固定的情况）
    static func labelWithHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let attr = [NSAttributedString.Key.font: font]
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attr, context: nil).size
        return strSize.height
    }

    /// iMarket: 通过文字计算label的高度（宽度固定的情况）
    static func labelWithWidth(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let attr = [NSAttributedString.Key.font: font]
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attr, context: nil).size
        return strSize.width
    }

    /// iMarket: 通过文字计算label的高度（带有富文本的情况）
    static func labelWithSpaceHeight(text: String, attr: [NSAttributedString.Key: Any], width: CGFloat) -> CGFloat {
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attr, context: nil).size

        return size.height
    }

    // 计算label的行数
    static func getRealLabelTextLines(labelText: String, width: CGFloat, font: UIFont) -> Int {
        // 计算理论上显示所有文字需要的尺寸
        let rect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let labelTextSize = (labelText as NSString)
            .boundingRect(with: rect, options: .usesFontLeading, attributes: [NSAttributedString.Key.font: font], context: nil)
        // 计算理论上需要的行数
        let labelTextLines = Int(ceil(CGFloat(labelTextSize.height) / font.lineHeight))
        return labelTextLines
    }
}

public extension UITextField {
    // 获取 NSAttributedString
    func placeholder(_ text: String, _ color: UIColor) {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
