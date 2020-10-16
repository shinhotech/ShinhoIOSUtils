//
//  UIControl+AXExtension.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/10/16.
//

import UIKit



/// 连续两次点击控件的时间间隔
extension UIControl {
    private struct UIControlEventKey {
        static let ignoreEventKey = UnsafeRawPointer.init(bitPattern: "ignoreEventKey".hashValue)!
        static let acceptEventIntervalKey = UnsafeRawPointer.init(bitPattern: "acceptEventIntervalKey".hashValue)!
    }
    
    
    static func ax_swizzleSendAction() {
//        UIControl.swizzleMethodSelector(#selector(sendAction(_:to:for:)), withSelector: #selector(ax_sendAction(_:to:for:)))
    }
    
    
    private var ax_ignoreEvent: Bool? {
        set {
            objc_setAssociatedObject(self, UIControlEventKey.ignoreEventKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let ignore = objc_getAssociatedObject(self, UIControlEventKey.ignoreEventKey) as? Bool {
                return ignore
            }
            return false
        }
    }
    
    public var ax_acceptEventInterval: Float? {
        set {
            objc_setAssociatedObject(self, UIControlEventKey.acceptEventIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIControlEventKey.acceptEventIntervalKey) as? Float
        }
    }
    

    @objc private func ax_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard ax_ignoreEvent == false else {
            return
        }
        let interval = ax_acceptEventInterval ?? 0
        if interval > 0 {
            ax_ignoreEvent = true
            DispatchQueue.main.asyncAfter(deadline:.now() + .milliseconds(Int(interval * 1000)), execute: {
                self.ax_ignoreEvent = false
            })
        }
        ax_sendAction(action, to: target, for: event)
    }
}

