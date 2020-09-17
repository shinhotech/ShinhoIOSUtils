//
//  UserDefaultsWrapper.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/16.
//

import UIKit

/// defaultT:
/// 当包装属性为可选的时候, 默认值可以为 nil,
/// 当包装属性为非可选的时候, 必须有默认值
@propertyWrapper
struct UserDefaultWrapper<T> {
    var key: String
    var defaultT: T!
    var wrappedValue: T! {
        get { (UserDefaults.standard.object(forKey: key) as? T) ?? defaultT }
        nonmutating set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
    
    init(_ key: String, _ defaultT: T! = nil) {
        self.key = key
        self.defaultT = defaultT
    }
}

/// for codable
@propertyWrapper
struct UserDefaultJsonWrapper<T: Codable> {
    var key: String
    var defaultT: T!
    var wrappedValue: T! {
        get {
            guard let jsonString = UserDefaults.standard.string(forKey: key) else { return defaultT }
            guard let jsonData = jsonString.data(using: .utf8) else { return defaultT }
            guard let value = try? JSONDecoder().decode(T.self, from: jsonData) else { return defaultT }
            return value
        }
        set {
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(newValue) else { return }
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            UserDefaults.standard.set(jsonString, forKey: key)
        }
    }
    
    init(_ key: String, _ defaultT: T! = nil) {
        self.key = key
        self.defaultT = defaultT
    }
}

struct UserDefaultWrappers {
    /// 图片是否拼接成功过
    @UserDefaultWrapper("normalBubbleViewKey", false)
    static var isNormalBubbleView: Bool!
    
    @UserDefaultWrapper("spliceBubbleViewKey", false)
    static var isSpliceBubbleView: Bool!
        
    @UserDefaultWrapper("presetValueKey")
    static var presetValue: Date?
    
    
    @UserDefaultWrapper("userId")
    static var userId: String?
    
    @UserDefaultWrapper("token")
    static var token: String?
    
    @UserDefaultWrapper("appVersion")
    static var appVersion: String?
    
    @UserDefaultWrapper("locationVersion")
    static var locationVersion: String?

    @UserDefaultWrapper("hasUpdateLocation", false)
    static var hasUpdateLocation: Bool!
    
    @UserDefaultWrapper("enterManagerVisitPlanCount", 0)
    static var enterManagerVisitPlanCount: Int!
    
    @UserDefaultWrapper("isFirstUsageMaintainCamera", false)
    static var isFirstUsageMaintainCamera: Bool!
    
    @UserDefaultWrapper("MaintainSliderPercent", 0.75)
    static var maintainSliderPercent: Float!
    
    @UserDefaultWrapper("MaintainCameraFlashType", 0)
    static var maintainCameraFlashType: Int!
    
    @UserDefaultWrapper("isMaintainCameraGridOn", false)
    static var isMaintainCameraGridOn: Bool!
    
    @UserDefaultWrapper("systemCameraKey", false)
    static var isSystemCamera: Bool!
    
    @UserDefaultWrapper("organizationStarred", [])
    static var organizationStarred: [String]!
}
