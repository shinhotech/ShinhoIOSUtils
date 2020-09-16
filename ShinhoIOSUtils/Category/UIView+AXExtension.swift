//
//  UIView+AXExtension.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/16.
//

import UIKit


extension UIView {
    func enumSubview(_ closure: @escaping (UIView) -> Bool) {
        let action = {
            for subview in self.subviews {
                if closure(subview) { return }
            }
            for subview in self.subviews {
                if !subview.subviews.isEmpty {
                    subview.enumSubview(closure)
                }
            }
        }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                action()
            }
        } else {
            action()
        }
        
    }
}




public extension UIWindow {
    
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}


private var touchBeganKey: Void?
private var touchMovedKey: Void?
private var touchesCancelledKey: Void?
private var touchesEndedKey: Void?
extension UIView {
    var snapshotImage: UIImage? {
        var image: UIImage?
        let rect = bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var touchBegan: ((Set<UITouch>, UIEvent?) -> ())? {
        set {
            objc_setAssociatedObject(self, &touchBeganKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &touchBeganKey) as? ((Set<UITouch>, UIEvent?) -> ())
        }
    }
    
    var touchMoved: ((Set<UITouch>, UIEvent?) -> ())? {
        set {
            objc_setAssociatedObject(self, &touchMovedKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &touchMovedKey) as? ((Set<UITouch>, UIEvent?) -> ())
        }
    }
    
    var touchesCancelled: ((Set<UITouch>, UIEvent?) -> ())? {
        set {
            objc_setAssociatedObject(self, &touchesCancelledKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &touchesCancelledKey) as? ((Set<UITouch>, UIEvent?) -> ())
        }
    }
    
    var touchesEnded: ((Set<UITouch>, UIEvent?) -> ())? {
        set {
            objc_setAssociatedObject(self, &touchesEndedKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &touchesEndedKey) as? ((Set<UITouch>, UIEvent?) -> ())
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBegan?(touches, event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved?(touches, event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesCancelled?(touches, event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesEnded?(touches, event)
    }
}



