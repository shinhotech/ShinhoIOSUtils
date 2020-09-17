//
//  SystemConfigure.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/16.
//

import UIKit

class SystemConfigure {
    static let shared = SystemConfigure()
    /// 当前app版本
    let appVersion: String
    /// 第一次安装App，或者删掉重新安装
    let isFirstInstall: Bool
    /// 更新版本
    let isUpdateVersion: Bool
    /// 手机模型名
    let modelName: String
    /// 系统版本
    let systemVersion: String
    
    var isSimulator: Bool {
        return modelName == "Simulator"
    }
    
    /// 当前App版本号
    var appVersionNum: Int? {
        var version = 0
        for (index, sub) in UIApplication.appVersion.split(separator: ".").enumerated() {
            version += Int(powf(10, Float(3 - index))) * (sub.description.int ?? 0)
        }
        return version
    }
    
    var networkStatus: String {
        return getNetworkStatus()
    }
    
    private init() {
        appVersion = UIApplication.appVersion
        let oldVersion = UserDefaultWrappers.appVersion
        isFirstInstall = oldVersion == nil
        isUpdateVersion = oldVersion != appVersion
        modelName = UIDevice.modelName
        systemVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
    
    private func getNetworkStatus() -> String {
        let noConnect = "NOT REACHABLE"
        let statusBarOpt = UIApplication.shared.value(forKeyPath: "_statusBar")
        guard let statusBar = statusBarOpt as? UIView else { return noConnect }
        var status = noConnect
        statusBar.enumSubview { subview in
            let typeString = String(describing: type(of: subview))
            if typeString == "_UIStatusBarWifiSignalView" {
                status = "WIFI"
                return true
            } else if typeString == "_UIStatusBarStringView" {
                if let state = subview.value(forKeyPath: "_originalText") as? String, state.contains("G") {
                    status = state
                    return true
                }
            } else if typeString == "UIStatusBarDataNetworkItemView" {
                if let state = subview.value(forKeyPath: "dataNetworkType") as? Int {
                    switch state {
                    case 0:
                        status = noConnect
                    case 1:
                        status = "2G"
                    case 2:
                        status = "3G"
                    case 3:
                        status = "4G"
                    case 5:
                        status = "WIFI"
                    default:
                        status = noConnect
                    }
                }
                return true
            }
            return false
        }
        return status
    }
}
