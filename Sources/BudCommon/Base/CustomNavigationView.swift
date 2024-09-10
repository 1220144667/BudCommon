//
//  File.swift
//  
//
//  Created by 文伍 on 2024/9/6.
//

import Foundation
import SnapKit
import SwiftTheme
import UIKit

class CustomNavigationView: UIView {
    let backButton = UIButton()

    let rightButton = UIButton()

    let label = UILabel()

    let line = UIView()

    var hiddenBackButton: Bool = false {
        didSet {
            let backWidth = hiddenBackButton ? 0 : 40
            backButton.snp.updateConstraints { make in
                make.width.equalTo(backWidth)
            }
            let labelLeft = hiddenBackButton ? 20 : 0
            label.snp.updateConstraints { make in
                make.left.equalTo(self.backButton.snp.right).offset(labelLeft)
            }
        }
    }

    var hiddenRightButton: Bool = true {
        didSet {
            rightButton.isHidden = hiddenRightButton
        }
    }

    var hiddenLine: Bool = true {
        didSet {
            line.isHidden = hiddenLine
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        theme_backgroundColor = BudColor.navigationColor
        label.theme_textColor = BudColor.textColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        line.theme_backgroundColor = BudColor.separatorColor
        // backButton.imageEdgeInsets = UIEdgeInsets (top: 0, left: -10, bottom: 0, right: 10)
        backButton.setImage(UIImage(named: "common_back_icon"), for: .normal)
        backButton.theme_setTitleColor(BudColor.textColor, forState: .normal)
        addSubview(backButton)
        addSubview(rightButton)
        addSubview(label)
        addSubview(line)
        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        label.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalTo(self.backButton.snp.centerY).offset(0)
            make.left.equalTo(self.backButton.snp.right).offset(0)
            make.right.equalTo(-80)
        }

        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.backButton.snp.centerY)
            make.right.equalTo(-10)
            make.width.equalTo(50)
            make.height.equalTo(44)
        }

        line.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
}
