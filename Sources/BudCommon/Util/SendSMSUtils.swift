//
//  SendSMSUtils.swift
//  BudChat
//
//  Created by lai A on 2024/1/3.
//  Copyright © 2024 BudChat LLC. All rights reserved.
//

import Foundation
import MessageUI

open class SendSMSUtils: NSObject, MFMessageComposeViewControllerDelegate {
    private static var `default`: SendSMSUtils?

    public static var sharedInstance: SendSMSUtils {
        if let instance = SendSMSUtils.default {
            return instance
        }
        let instance = SendSMSUtils()
        SendSMSUtils.default = instance
        return instance
    }

    private func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }

    /*
      // 显示姓名
      var name = recipient.name
      if name.isEmpty {
          name = recipient.mobileArray.first ?? ""
      }
     */
    private func configuredMessageComposeViewController(name: String?, phone: String) -> MFMessageComposeViewController {
        let n = (name == nil) ? phone : name!
        let url = "https://apps.apple.com/us/app/budchat/id6464466941"
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = [phone]
        messageComposeVC.body = String(format: "Hey [%@]! Let's talk on BudChat. We can connect easily with data free messages and calls, and also make payments instantly. Get it on your device today \nAndroid:\n https://play.google.com/store/apps/details?id=com.pengbei.budchat\n iOS:\n %@", n, url)
        return messageComposeVC
    }

    func sendSMS(name: String?,
                 phone: String,
                 presentVC: UIViewController)
    {
        if canSendText() {
            let messageVC = configuredMessageComposeViewController(name: name, phone: phone)
            presentVC.present(messageVC, animated: true, completion: nil)
        }
    }

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            var toastMsg = ""
            switch result {
            case .cancelled:

                toastMsg = "Message unsent"
                print("取消发送")
            case .sent:

                toastMsg = "The message has been sent"
                print("消息已发送")
            case .failed:

                toastMsg = "Message sending failed"
                print("发送失败")
            @unknown default:
                print("")
            }

            Bud.makeToast(message: toastMsg)
        }
    }
}
