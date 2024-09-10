//
//  BaseViewController.swift
//  BudMall
//
//  Created by 洪陪 on 2024/3/13.
//

import SwiftTheme
import UIKit

public class BaseViewController<Container: UIView>: UIViewController, RequestExpiresable {
    
    // ----------- 容器View -----------
    public var container: Container { view as! Container }

    // ----------- 是否隐藏NavigationBar -----------
    public var hidenNavigationBar = false

    // ----------- 返回事件闭包、如果实现此闭包则需要手动调用pop函数 -----------
    public var backClosure: (() -> Void)?

    public override func loadView() {
        super.loadView()
        if view is Container { return }
        view = Container(frame: UIScreen.main.bounds)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景色
        view.theme_backgroundColor = BudColor.backgroundColor

        // ----------- 设置返回按钮 -----------
        let leftItem = UIBarButtonItem(image: UIImage(named: "navigation-back"), style: .plain, target: self, action: #selector(self.backAction))
        navigationItem.leftBarButtonItem = leftItem

        // ----------- 检查登录状态及刷新token -----------
        if !UserManager.shared.isLogin { return }
        if self.decideExpires() == false {
            self.loadData()
            return
        }

        // ----------- 更新refresh信息 -----------
        self.refreshToken().done { info in
            // 更新user信息
            guard let auth = info else { return }
            guard var user = UserManager.shared.user else { return }
            user.auth = auth
            UserManager.shared.saveUser(user)
            self.loadData()
        }.catch { error in
            #if DEBUG
            let err = error as NSError
            print(err.domain)
            #endif
        }
    }

    // ----------- 加载数据 -----------
    public func loadData() {}

    // ----------- view点击事件 -----------
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.container.endEditing(true)
    }

    // ----------- 返回事件、外部可以实现闭包以拦截此事件 -----------
    @objc
    private func backAction() {
        if let back = backClosure {
            back()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }

    // 添加释放检测
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(Self.self)) dealloc")
        #endif
    }
}
