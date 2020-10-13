//
//  UIFontUtil.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/23.
//

import UIKit

private let pingFangSCLight = "PingFangSC-Light"
private let pingFangSCRegular = "PingFangSC-Regular"
private let pingFangSCMedium = "PingFangSC-Medium"
private let pingFangSCSemibold = "PingFangSC-Semibold"
private let pingFangHKRegular = "PingFangHK-Regular"

public extension UIFont {
    /// PingFangSC-Light
    static func pfscLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: pingFangSCLight, size: size)!
    }
    
    /// PingFangSC-Regular
    static func pfscRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: pingFangSCRegular, size: size)!
    }
    /// PingFangSC-Medium
    static func pfscMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: pingFangSCMedium, size: size)!
    }
    
    /// PingFangSC-Semibold
    static func pfscSemibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: pingFangSCSemibold, size: size)!
    }
    
    /// PingFangHK-Regular
    static func pfhkRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: pingFangHKRegular, size: size)!
    }
    
    var height: CGFloat {
        switch pointSize {
        case 12:
            return 16
        case 14,16:
            return 18
        case 19:
            return 19
        case 24:
            return 28
        default:
            return 18
        }
    }
}
