//
//  Shortcut.swift
//  FSFA
//
//  Created by Lcm on 2018/4/5.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

// MARK: - common shortcuts

/// status bar height
var statusBarHeight: CGFloat {
    return isNotchScreen ? 44 : 20
}

/// window safeAreaInsets
var windowSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.keyWindow?.safeAreaInsets)!
    } else {
        return .zero
    }
}

/// 是不是刘海屏
var isNotchScreen: Bool {
    if #available(iOS 11.0, *) {
        if windowSafeAreaInsets.top > 20 {
            return true
        }
    }
    return false
}

/// current device is or not iPhoneX
let isIPhoneX = UIScreen.main.bounds.height >= 812

/// appDelegate
var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

/// screen height
let screenHeight = UIScreen.main.bounds.height

/// screen width
let screenWidth = UIScreen.main.bounds.width
