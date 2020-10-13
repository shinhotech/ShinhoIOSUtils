//
//  Array+AXExtension.swift
//  FSFA
//
//  Created by Yan Hu on 2018/4/28.
//  Copyright © 2018年 shinho. All rights reserved.
//

import Foundation

/*
 var arr = [1,2,3,4,5]
 arr[[0,2,3]] print 1,3,4
 arr[[0,2,3]] = [-1,-3,-4]
 */
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set {
            for (index, i) in input.enumerated() {
                assert(i < count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
    
    /// json 数组排序
    func sortedJsonString() -> String {
        let array = self
        var arr: Array<String> = []
        var signString = "["
        for value in array {
            if let value = value as? Dictionary<String,Any> {
                arr.append(value.sortedJsonString())
            }else if let value = value as? Array<Any> {
                arr.append(value.sortedJsonString())
            }else{
                arr.append("\"\(value)\"")
            }
        }
        arr.sort { $0 < $1 }
        signString += arr.joined(separator: ",")
        signString += "]"
        return signString
    }
}

extension Array where Element: NSCopying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy() as! Element)
        }
        return copiedArray
    }
}


extension Array where Element == JSONObject {
    func jsonString() -> String? {
        var result = ""
        for item in self {
            if let str = item.jsonString() {
                result += str
            }
        }
        if !result.isEmpty {
            return result
        }
        return nil
    }
    
    var dataValue: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
