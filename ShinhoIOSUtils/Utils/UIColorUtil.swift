//
//  UIColorUtil.swift
//  ShinhoIOSUtils
//
//  Created by Yan Hu on 2020/9/16.
//

import UIKit
import SwifterSwift

public extension UIColor {
    /// rgba(0,0,0,0.02) - #000000
    static let black02 = UIColor.black.withAlphaComponent(0.02)
    /// rgba(0,0,0,0.06) - #000000
    static let black06 = UIColor.black.withAlphaComponent(0.06)
    /// rgba(0,0,0,0.1) - #000000
    static let black10 = UIColor.black.withAlphaComponent(0.10)
    /// rgba(0,0,0,0.12) - #000000
    static let black12 = UIColor.black.withAlphaComponent(0.12)
    /// rgba(0,0,0,0.14) - #000000
    static let black14 = UIColor.black.withAlphaComponent(0.14)
    /// rgba(0,0,0,0.2) - #000000
    static let black20 = UIColor.black.withAlphaComponent(0.20)
    /// rgba(0,0,0,0.38) - #000000
    static let black38 = UIColor.black.withAlphaComponent(0.38)
    /// rgba(0,0,0,0.54) - #000000
    static let black54 = UIColor.black.withAlphaComponent(0.54)
    /// rgba(0,0,0,0.7) - #000000
    static let black70 = UIColor.black.withAlphaComponent(0.70)
    /// rgba(0,0,0,0.5) - #000000
    static let black50 = UIColor.black.withAlphaComponent(0.50)
    /// rgba(0,0,0,0.85) - #000000
    static let black85 = UIColor.black.withAlphaComponent(0.85)
    /// rgba(255,255,255,0.2) - #ffffff
    static let white20 = UIColor.white.withAlphaComponent(0.20)
    /// rgba(255,255,255,0.4) - #ffffff
    static let white40 = UIColor.white.withAlphaComponent(0.40)
    /// rgba(255,255,255,0.5) - #ffffff
    static let white50 = UIColor.white.withAlphaComponent(0.50)
    /// rgba(255,255,255,0.65) - #ffffff
    static let white65 = UIColor.white.withAlphaComponent(0.65)
    /// rgba(255,255,255,0.7) - #ffffff
    static let white70 = UIColor.white.withAlphaComponent(0.70)
    /// rgba(255,255,255,0.9) - #ffffff
    static let white90 = UIColor.white.withAlphaComponent(0.90)
    /// rgba(249,253,254,1) - #F9FDFE
    static let whitef9 = UIColor(hex: 0xf9fdfe)!
    /// rgba(216,216,216,1) - #d8d8d8
    static let whited8 = UIColor(hex: 0xd8d8d8)!
    /// rgba(164,164,164,1) - #a4a4a4
    static let browna4 = UIColor(hex: 0xa4a4a4)!
    /// rgba(158,158,158,1) - #9e9e9e
    static let gray9e = UIColor(hex: 0x9e9e9e)!
    /// rgba(229,229,229,1) - #e5e5e5
    static let graye5 = UIColor(hex: 0xe5e5e5)!
    /// rgba(74,74,74,1) - #4a4a4a
    static let gray4a = UIColor(hex: 0x4a4a4a)!
    /// rgba(243,243,243,1) - #f3f3f3
    static let grayf3 = UIColor(hex: 0xf3f3f3)!
    /// rgba(245,245,245,1) - #f5f5f5
    static let grayf5 = UIColor(hex: 0xf5f5f5)!
    /// rgba(250,250,250,1) - #fafafa
    static let grayfa = UIColor(hex: 0xfafafa)!
    /// rgba(147,147,147,0.9) - #939393
    static let gray93 = UIColor(hex: 0x939393)!
    /// rgba(151,151,151,1) - #979797
    static let gray97 = UIColor(hex: 0x979797)!
    /// rgba(250,250,250,0.9) - #fafafa
    static let grayfa90 = UIColor(hex: 0xfafafa)!.withAlphaComponent(0.9)
    /// rgba(218,226,232) - #dae2e8
    static let grayda = UIColor(hex: 0xdae2e8)!
    /// rgba(218,62,65,1) - #DA3E41
    static let redda = UIColor(hex: 0xDA3E41)!
    /// rgba(240,80,83,1) - #f05053
    static let redf0 = UIColor(hex: 0xf05053)!
    /// rgba(240,80,83,0.1) - #f05053
    static let redf010 = UIColor(hex: 0xf05053)!.withAlphaComponent(0.1)
    /// rgba(244,91,86,1) - #f45b56
    static let redf4 = UIColor(hex: 0xf45b56)!
    /// rgba(244,91,86,0.15) - #f45b56
    static let redf415 = UIColor(hex: 0xf45b56)!.withAlphaComponent(0.15)
    /// rgba(247,59,49,1) - #f73b31
    static let redf7 = UIColor(hex: 0xf73b31)!
    /// rgba(133,197,69,1) - #85c545
    static let green85 = UIColor(hex: 0x85c545)!
    /// rgba(120,172,68,1) - #78AC44
    static let green78 = UIColor(hex: 0x78ac44)!
    /// rgba(239,136,95,1) - #ef885f
    static let orangeef = UIColor(hex: 0xef885f)!
    /// rgba(226,234,237,1) - #e2eaed
    static let cyane2 = UIColor(hex: 0xe2eaed)!
    /// rgba(190,218,223,1) - #bedadf
    static let bluebe = UIColor(hex: 0xbedadf)!
    /// rgba(125,174,182,1) - #bedadf
    static let blue7d = UIColor(hex: 0x7daeb6)!
    /// 默认渐变色左侧颜色
    static let leftGradientColor = UIColor(hex: 0xff7e5f)!
    /// 默认渐变色右侧颜色
    static let rightGradientColor = redf0
}
