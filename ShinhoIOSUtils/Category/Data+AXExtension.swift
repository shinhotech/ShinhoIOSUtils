//
//  Data+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/5/12.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

extension Data {
    var jsonValue: JSONObject? {
        return jsonObject as? JSONObject
    }
    var jsonsValue: [JSONObject]? {
        return jsonObject as? [JSONObject]
    }
    var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}


extension Collection {
    func jsonString() -> String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                let string = String.init(data: data, encoding: .utf8)
                return string
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
}

extension NSObject {
    func jsonString() -> String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                let string = String.init(data: data, encoding: .utf8)
                return string
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
}
