//
//  UIView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import SnazzyAccessibility
import UIKit

enum BoundsType {
    case vertical
    case horizontal
    case full
}

public extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
    
//    func zoom(duration: CFTimeInterval = 0.5, by: CGFloat = 1.15) {
//        UIView.animate(
//            withDuration: duration - 0.2,
//            delay: 0.0,
//            options: UIView.AnimationOptions.curveEaseIn,
//            animations: { [weak self] in
//                self?.transform = CGAffineTransform.identity.scaledBy(x: by, y: by)
//            }, completion: { finished in
//                if !finished { return }
//                UIView.animate(withDuration: 0.2) { [weak self] in
//                    self?.transform = CGAffineTransform.identity
//                }
//            }
//        )
//    }
    
//    func shake(duration: CFTimeInterval = 0.6) {
//        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//        animation.duration = duration
//        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
//        layer.add(animation, forKey: "shake")
//    }
    
//    func shakeWithColor() {
//        guard let previousBorderColor = self.layer.borderColor else { return }
//        self.layer.borderColor = UIColor.dmsCoral.cgColor
//        shake(duration: 0.4)
//        animateBorderColor(toColor: previousBorderColor, duration: 1.5)
//        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
//    }
    
//    func animateBorderColor(toColor: CGColor, duration: Double) {
//        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
//        animation.fromValue = layer.borderColor
//        animation.toValue = toColor
//        animation.duration = duration
//        layer.add(animation, forKey: "borderColor")
//        layer.borderColor = toColor
//    }
    
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
    
    func addBottomLineView(color: UIColor = UIColor.lightGray, height: CGFloat = 1.0, leftMargin: CGFloat = 0.0, rightMargin: CGFloat = 0.0) {
        let view = UIView(backgroundColor: color)
        self.addSubview(view)
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMargin).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightMargin).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @available(iOS 11.0, *)
    internal func bindFrameToSafeLayoutArea(withConstant constant: CGFloat, boundType: BoundsType) {
        guard let superView = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        switch boundType {
        case .vertical:
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -1.0 * constant).isActive = true
        case .horizontal:
            self.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor, constant: -1.0 * constant).isActive = true
            self.leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
        case .full:
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -1.0 * constant).isActive = true
            self.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor, constant: -1.0 * constant).isActive = true
            self.leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
        }
    }
    
    func getTopAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    func getBottomAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    func getRightAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
    func getLeftAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    func getBottomHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.bottom
        }
        return 0.0
    }
    
    func getTopHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.top
        }
        return 0.0
    }
    
    internal func bindFrameToSuperviewBounds(withConstant constant: CGFloat, boundType: BoundsType) {
        guard let superView = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        switch boundType {
        case .vertical:
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant).isActive = true
            superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true
        case .horizontal:
            self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: constant).isActive = true
            superView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: constant).isActive = true
        case .full:
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant).isActive = true
            self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: constant).isActive = true
            superView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: constant).isActive = true
            superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true
        }
    }
    
    internal func bind(withConstant constant: CGFloat, boundType: BoundsType) {
        if #available(iOS 11.0, *) {
            self.bindFrameToSafeLayoutArea(withConstant: constant, boundType: boundType)
        }else{
            self.bindFrameToSuperviewBounds(withConstant: constant, boundType: boundType)
        }
    }
    
    internal func bindFrameGreaterOrEqualToSuperviewBounds(withConstant constant: CGFloat, boundType: BoundsType) {
        guard let superView = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        switch boundType {
        case .vertical:
            self.topAnchor.constraint(greaterThanOrEqualTo: superView.topAnchor, constant: constant).isActive = true
            superView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: constant).isActive = true
        case .horizontal:
            self.leftAnchor.constraint(greaterThanOrEqualTo: superView.leftAnchor, constant: constant).isActive = true
            superView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: constant).isActive = true
        case .full:
            self.topAnchor.constraint(greaterThanOrEqualTo: superView.topAnchor, constant: constant).isActive = true
            self.leftAnchor.constraint(greaterThanOrEqualTo: superView.leftAnchor, constant: constant).isActive = true
            superView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: constant).isActive = true
            superView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: constant).isActive = true
        }
    }
    
    func assignSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func matchEdges(to other: UIView, horizontalConstants: CGFloat = 0.0, verticalConstants: CGFloat = 0.0) {
        other.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalConstants).isActive = true
        rightAnchor.constraint(equalTo: other.rightAnchor, constant: horizontalConstants).isActive = true
        other.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstants).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: verticalConstants).isActive = true
    }
    
    func getImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView: Accessible { }
