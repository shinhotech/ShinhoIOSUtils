//
//  Dictionary+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/5/12.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit


extension Dictionary where Key == String, Value == Any {
    var dataValue: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    mutating func merge(from json: JSONObject) {
        json.forEach { (key, value) in
            let selfValue = self[key]
            guard let unwrapper = selfValue, !(unwrapper is NSNull) else {
                self[key] = value
                return
            }
            if let dic = value as? JSONObject,
                var origin = self[key] as? JSONObject {
                origin.merge(from: dic)
                self[key] = origin
            }
        }
    }
}

extension Dictionary {
    /// json 转字符串 排序
    func sortedJsonString() -> String {
        let tempDic = self as! Dictionary<String,Any>
        var keys = Array<String>()
        for key in tempDic.keys {
            keys.append(key)
        }
        keys.sort { $0 < $1 }
        var signString = "{"
        var arr: Array<String> = []
        for key in keys {
            let value = tempDic[key]
            if let value = value as? Dictionary<String,Any> {
                arr.append("\"\(key)\":\(value.sortedJsonString())")
            }else if let value = value as? Array<Any> {
                arr.append("\"\(key)\":\(value.sortedJsonString())")
            }else{
                arr.append("\"\(key)\":\"\(tempDic[key]!)\"")
            }
        }
        signString += arr.joined(separator: ",")
        signString += "}"
        return signString
    }
}


