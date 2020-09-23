//
//  String+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/3/23.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import CommonCrypto
import CryptoKit

extension String {
    
    /// "yyyy.MM.dd HH:mm" to Date
    var dateTime: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.date(from: self)
    }
    
    /// "yyyy-MM-dd HH:mm:ss" to "yyyy.MM.dd HH:mm"
    var format16DateString: String? {
        guard count == 19 else { return self }
        let date = self.date(withFormat: "yyyy-MM-dd HH:mm:ss")
        return date?.string(withFormat: "yyyy.MM.dd HH:mm")
    }
    
    ///  string is nil
    var orNil: String? {
        return isEmpty ? nil : self
    }
    
    /// string is empty
    var orEmpty: String {
        return isEmpty ? "" : self
    }
    
    /// 默认是 元 string 转 string 分
    var fen: Int? {
        guard let value = NumberFormatter().number(from: self) as? Double else { return nil }
        return Int(round(value * 100.0))
    }
    
    /// 去除空格和\n
    var noSpaceAndNewline: String {
        var temp = trimmingCharacters(in: .whitespaces)
        temp = temp.trimmingCharacters(in: .newlines)
        return temp
    }
    
    /// string to json
    var jsonValue: JSONObject? {
        return data(using: .utf8)?.jsonValue
    }
    
    /// string to json array
    var jsonsValue: [JSONObject]? {
        return data(using: .utf8)?.jsonsValue
    }
    
    /// string to any
    var jsonObject: Any? {
        return data(using: .utf8)?.jsonObject
    }
    
    /// 验证密码
    var isValidPassword: Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    
    /// 是 http 格式的 url 或 key
    var isUrlString: Bool {
        
        // d374ce6b-8579-4f60-a9a9-734b6f36c2f9.jpeg
        if !(URL(string: self)?.isFileURL ?? false), !isEmpty { return true }
        
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", "(http|https):\\/\\/([\\w.]+\\/?)\\S*")
        return predicate.evaluate(with: self)
    }
    
    /// 是否是 file://, 目前不是 http 则认为是本地图片
    var isFileUrl: Bool {
        return !isUrlString
    }
    
    /// 图片 cache 存储位置
    var imageCachePath: String {
        guard let url = URL(string: self), url.isFileURL else { return self }
        let realUrl = UIImage.imageCacheURL.appendingPathComponent(url.lastPathComponent)
        return realUrl.absoluteString
    }
    
    /// 是否存在这个 path
    var existsPath: Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: self)
    }
    
    /// 返回 font 字体当前 string 的 size
    /// - Parameter font: font
    /// - Returns: size
    func size(with font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }
    
    ///  返回 maxWidth 下, font 大小字体的高度
    /// - Parameters:
    ///   - font: font
    ///   - maxWidth: max width
    /// - Returns: height
    func height(with font: UIFont, maxWidth: CGFloat = screenWidth) -> CGFloat {
        return (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: 0), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
    }
    
    ///  小数点处理
    /// - Returns: 默认两位
    func handleZeroDot() -> String {
        if let doubleNumber = self.double() {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            formatter.usesGroupingSeparator = false
            return formatter.string(from: NSNumber.init(value: doubleNumber)) ?? ""
        }
        return self
    }
    
    /// 转钱格式
    /// - Returns: 两位小数
    func moneyString() -> String {
        if let doubleNumber = self.double() {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber.init(value: doubleNumber)) ?? ""
        }
        return self
    }
    
    ///  sub string
    /// - Parameters:
    ///   - left: 左
    ///   - right: 右
    /// - Returns: 截取的数组
    func sub(left: String, right: String) -> [String] {
        var results = [String]()
        let pattern = "(?<=\(left)).*?(?=\(right))"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let res = regex?.matches(in: self, options: [], range: NSRange.init(location: 0, length: count))
        for result in res ?? [] {
            results.append((self as NSString).substring(with: result.range))
        }
        return results
    }
    
    /// 打印 json
    /// - Returns: json string
    func jsonFormatPrint() -> String {
        var result = ""
        var level = 0
        for c in self {
            switch c {
            case "{", "[":
                level += 1
                fallthrough
            case ",":
                result.append(c)
                result.append("\n")
                result += String(repeating: "    ", count: level)
            case "]", "}":
                level -= 1
                result.append("\n")
                result += String(repeating: "    ", count: level)
                result.append(c)
            default:
                result.append(c)
            }
        }
        return result
    }
    
    /// 去掉预设值前缀
    var trimPresetPrefix: String {
        return self
    }
    
    /// 添加预设值前缀
    var addPresetPrefix: String {
        return self
    }
}

extension String {
    //Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        if let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) {
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
            length: utf16.distance(from: from, to: to))
        }
        return nil
    }
     
    //Range转换为NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

// Defines types of hash string outputs available
public enum HashOutputType {
    // standard hex string output lowercased
    case hexLowercased
    // standard hex string output uppercased
    case hexUppercased
    // base 64 encoded string output
    case base64
}

// Defines types of hash algorithms available
public enum HashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512

    var length: Int32 {
        switch self {
        case .md5: return CC_MD5_DIGEST_LENGTH
        case .sha1: return CC_SHA1_DIGEST_LENGTH
        case .sha224: return CC_SHA224_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha384: return CC_SHA384_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        }
    }
}

public extension String {

    /// Hashing algorithm for hashing a string instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of output desired, defaults to .hex.
    /// - Returns: The requested hash output or nil if failure.
    func hashed(_ type: HashType, output: HashOutputType = .hexLowercased) -> String? {

        // convert string to utf8 encoded data
        guard let message = data(using: .utf8) else { return nil }
        return message.hashed(type, output: output)
    }
}

extension Data {
    // From Stackoverflow, see https://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift
    /// conert to hexencoded string
    public func hexString1(_ lowercased: Bool = true) -> String {
        let hexAlphabet = (lowercased ? "0123456789abcdef" : "0123456789ABCDEF").unicodeScalars.map { $0 }
        return String(reduce(into: "".unicodeScalars, { (result, value) in
            result.append(hexAlphabet[Int(value/16)])
            result.append(hexAlphabet[Int(value%16)])
        }))
    }
    
    // It's not as elegant, but it's about 10 times faster than function hexString1
    /// conert to hexencoded string
    public func hexString2(_ lowercased: Bool = true) -> String {
        let format = lowercased ? "%02hhx" : "%02hhX"
        return map { String(format: format, $0) }.joined()
    }
    
    /// Hashing algorithm for hashing a Data instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of hash output desired, defaults to .hex.
    ///   - Returns: The requested hash output or nil if failure.
    public func hashed(_ type: HashType, output: HashOutputType = .hexLowercased) -> String {
        if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *),
            type == .md5 {
            var md5 = Insecure.MD5()
            md5.update(data: self)
            let digest = md5.finalize().withUnsafeBytes { Data($0) }
            
            // return the value based on the specified output type.
            switch output {
            case .hexLowercased: return digest.hexString2()
            case .hexUppercased: return digest.hexString2(false)
            case .base64: return digest.base64EncodedString()
            }
        }
        
        // setup data variable to hold hashed value
        var digest = Data(count: Int(type.length))
        _ = digest.withUnsafeMutableBytes { (digestBytes) -> Bool in
            withUnsafeBytes({ (messageBytes) -> Bool in
                let length = CC_LONG(self.count)
                let messageAddress = messageBytes.baseAddress
                let digestAddress = digestBytes.bindMemory(to: UInt8.self).baseAddress
                switch type {
                case .md5:
                    if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
                        return true
                    } else {
                        CC_MD5(messageAddress, length, digestAddress)
                    }
                case .sha1: CC_SHA1(messageAddress, length, digestAddress)
                case .sha224: CC_SHA224(messageAddress, length, digestAddress)
                case .sha256: CC_SHA256(messageAddress, length, digestAddress)
                case .sha384: CC_SHA384(messageAddress, length, digestAddress)
                case .sha512: CC_SHA512(messageAddress, length, digestAddress)
                }
                return true
            })
        }

        // return the value based on the specified output type.
        switch output {
        case .hexLowercased: return digest.hexString2()
        case .hexUppercased: return digest.hexString2(false)
        case .base64: return digest.base64EncodedString()
        }
    }
}
