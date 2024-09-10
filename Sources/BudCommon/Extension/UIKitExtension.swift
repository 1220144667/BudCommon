//
//  UIKitExtension.swift
//  iAntique
//
//  Created by 文伍 on 2024/4/28.
//

import UIKit
import PromiseKit

enum BudFont {
    case regularFont(CGFloat)
    
    case mediumFont(CGFloat)
    
    case semiboldFont(CGFloat)
    
    case boldFont(CGFloat)
    
    case manropeFont(CGFloat)
    
    case customFont(String, CGFloat)
    
    var font: UIFont {
        switch self {
        case .regularFont(let size):
            return .systemFont(ofSize: size, weight: .regular)
        case .mediumFont(let size):
            return .systemFont(ofSize: size, weight: .medium)
        case .semiboldFont(let size):
            return .systemFont(ofSize: size, weight: .semibold)
        case .boldFont(let size):
            return .systemFont(ofSize: size, weight: .bold)
        case .manropeFont(let size):
            return UIFont(name: "Manrope", size: size) ?? .systemFont(ofSize: size)
        case .customFont(let name, let size):
            return UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
        }
    }
}

// MARK: ----------- UIButton创建 -----------
extension UIButton {
    
    func addBorder(side: ButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }

        self.layer.addSublayer(border)
    }

    func addBlurEffect() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView {
            self.bringSubviewToFront(imageView)
        }
    }
}

// MARK: ----------- UIControl点击事件 -----------
extension UIControl {
    /// 添加点击事件
    /// - Parameters:
    ///   - target: target
    ///   - action: action
    public func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    //扩大点击区域  最大为44*44
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds;
        //若点击区域小于44x44，则放大点击区域，否则保持原大小不变
        let widthDelta: CGFloat = max(44.0 - bounds.size.width, 0)
        let heightDelta: CGFloat  = max(44.0 - bounds.size.height, 0);
        bounds = bounds.insetBy(dx: -0.5*widthDelta, dy: -0.5*heightDelta)
        let isContain: Bool = bounds.contains(point)
        return isContain;
    }
}


public enum ButtonBorderSide {
    case top, bottom, left, right
}

//MARK: --- 设置圆角 ---
extension UIView {
    /// 设置部分圆角
    public func setCorner(by corners:UIRectCorner, with radii:CGFloat, rect: CGRect){
        let bezierpath: UIBezierPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let shape: CAShapeLayer = CAShapeLayer.init()
        shape.path = bezierpath.cgPath
        self.layer.mask = shape
    }
    
    /// 设置某几个角的圆角
    public func setCorner(by corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 设置渐变颜色
    public func setGradientColor(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, corner: CGFloat) {
        self.removeAllSublayers()
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = corner
        gradientLayer.frame = self.bounds
        // 设置渐变的主颜色(可多个颜色添加)
        gradientLayer.colors = colors
        // startPoint与endPoint分别为渐变的起始方向与结束方向, 它是以矩形的四个角为基础的,默认是值是(0.5,0)和(0.5,1)
        // (0,0)为左上角 (1,0)为右上角 (0,1)为左下角 (1,1)为右下角
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        // 将gradientLayer作为子layer添加到主layer上
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 移除渐变
    public func removeAllSublayers() {
        guard let sublayers =  self.layer.sublayers else {
            return
        }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
}

// MARK: ----------- 添加UIView点击事件 -----------
fileprivate typealias GestureClosure = ((_ gesture: UITapGestureRecognizer)->())

extension UIView {

    @objc private func didClickCallBack(_ sender: UITapGestureRecognizer) {
        action?(sender)
    }

    private struct RuntimeKey {
        static let kActionKey = UnsafeRawPointer.init(bitPattern: "ActionKey".hashValue)!
    }
    
    private var action: GestureClosure? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kActionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, RuntimeKey.kActionKey) as? GestureClosure
        }
    }

    /// 点击事件
    func whenTap(_ listener: @escaping ((_ sender: UITapGestureRecognizer)->())) {
        self.action = listener
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickCallBack(_ :)))
        self.addGestureRecognizer(tap)
    }
 }
