//
//  RequestUrl.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/16.
//

import Foundation

enum RequestUrl: String {
    /// 登录
    case login = "user/login"
    
    var url: String {
        return "BaseUrl.baseURL" + rawValue
    }

}
