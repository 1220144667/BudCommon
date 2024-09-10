//
//  BudToast.swift
//  BudMall
//
//  Created by 洪陪 on 2024/3/20.
//

import AdSupport
import UIKit
import Toast
import ProgressHUD

extension Bud {
    public static var uuid: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    // 展示toast
    static func makeToast(location: String, to view: UIView? = nil) {
        makeToast(message: location.localized(), to: view)
    }

    static func makeToast(message: String, to view: UIView? = nil) {
        DispatchQueue.main { [message, view] in
            self.showToast(message: message, duration: 2.0, position: .center, to: view)
        }
    }

    static func showToast(message: String, duration: TimeInterval, position: ToastPosition, to view: UIView? = nil) {
        if message.isEmpty { return }
        guard let toView = view else {
            keyWindow?.makeToast(message, duration: duration, position: position)
            return
        }
        toView.makeToast(message, duration: duration, position: position)
    }

    // 隐藏toast
    static func hideToast(to view: UIView? = nil) {
        guard let toView = view else {
            keyWindow?.hideToast()
            return
        }
        toView.hideToast()
    }
}

extension Bud {
    static let theme = UIColor.red
    // 展示顶部弹出的提示
    static func bannerHUD(title: String, message: String, delay: TimeInterval = 2) {
        ProgressHUD.banner(title, message, delay: delay)
    }

    static func animateHUD(text: String = "loading...", animation: AnimationType = .activityIndicator) {
        ProgressHUD.mediaSize = 100
        ProgressHUD.colorAnimation = theme
        ProgressHUD.colorProgress = theme
        ProgressHUD.animate(text, animation, interaction: false)
    }

    static func succeedHUD() {
        ProgressHUD.colorAnimation = theme
        ProgressHUD.colorProgress = theme
        ProgressHUD.succeed("TextSucceed".localized())
    }

    static func failedHUD() {
        ProgressHUD.colorAnimation = .red
        ProgressHUD.colorProgress = .red
        ProgressHUD.failed("TextFailed".localized())
    }

    static func hiddenHUD() {
        ProgressHUD.dismiss()
    }
}
