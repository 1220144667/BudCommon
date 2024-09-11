//
//  BaseContainer.swift
//  iAntique
//
//  Created by 文伍 on 2024/5/10.
//

import UIKit

open class BaseContainer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func commonInit() {}
}
