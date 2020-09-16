//
//  API.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/16.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire


typealias JSONObject = [String: Any]

enum ApiError: Swift.Error {
    case serverError(code: Int, msg: String)
    case logicError(code: Int, msg: String)
}



final class API {
    static let shared = API()
    private init() {}

    static let manager: Alamofire.Session = {
        
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20 // seconds
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
//
//    func request(_ method: Alamofire.HTTPMethod,
//                 _ requestUrl: RequestUrl,
//                 _ urlAbsoluteString: String? = nil,
//                 parameters: Any? = nil, manager: SessionManager? = nil) -> Observable<Any> {
//        return request(method, urlAbsoluteString ?? requestUrl.url, parameters: parameters, manager: manager).map({ result in
//            if method == .get {
//                CacheManager.shared.addData2CacheIfNeeded(obj: result, url: requestUrl, parameters: parameters, urlAbsoluteString: urlAbsoluteString)
//            }
//            return result
//        })
//    }
//
    func request(_ method: Alamofire.HTTPMethod,
                 _ url: String,
                 parameters: Any? = nil,
                 manager: Session? = nil) -> Observable<Any> {
        let headers = HTTPHeaders(getHeaders(url: url))
        func handleResponse(_ response: HTTPURLResponse, _ json: Any) -> Observable<Any> {

            let statusCode = response.statusCode
            guard statusCode == 200 else {
                return .error(ApiError.serverError(code: statusCode, msg: HTTPURLResponse.localizedString(forStatusCode: statusCode)))
            }
            // result
            if let dict = json as? JSONObject {
                let code = (dict["code"] as? Int) ?? -1
                guard code == 200 else {
                    return .error(ApiError.logicError(code: code, msg: (dict["msg"] as? String) ?? ""))
                }
                let result = dict["data"] ?? Void.self
                return .just(result)
            } else {
                return .just(json)
            }
        }

        // json
        if let json = parameters as? JSONObject {
            let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
            return API.manager.rx.responseJSON(method, url, parameters: json, encoding: encoding, headers: headers).flatMap (handleResponse)
        }
        // json list
        do {
            let originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try JSONEncoding.default.encode(originalRequest, withJSONObject: parameters)
            let result: Observable<(HTTPURLResponse, Any)> = RxAlamofire.request(encodedURLRequest).flatMap { $0.rx.responseJSON() }
            return result.flatMap(handleResponse)
        } catch {
            return .empty()
        }
    }


    static func parse<T: Decodable>(json: Any?, to model: T.Type) -> T? {
        guard let json = json else { return nil }
        guard JSONSerialization.isValidJSONObject(json) else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let ts = try container.decode(TimeInterval.self)
                return Date.init(timeIntervalSince1970: ts / 1000)
            })
            let model = try decoder.decode(model, from: data)
            return model
        } catch {
            print("decoder error:", error)
        }
        return nil
    }

    static func encode<T: Encodable>(model: T) -> Any? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom({ (date, encoder) in
                var container = encoder.singleValueContainer()
                try container.encode(Int(date.timeIntervalSince1970 * 1000))
            })
            let data = try encoder.encode(model)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            print("encoder error:", error)
        }
        return nil
    }

    private func getHeaders(url: String) -> [String:String] {
        var header = [String:String]()
        header["device"] = "iOS"
        header["appVersion"] = SystemConfigure.shared.appVersionNum?.string ?? ""
        header["phoneModel"] = SystemConfigure.shared.modelName
        header["softwareVersion"] = SystemConfigure.shared.systemVersion
        header["networkType"] = SystemConfigure.shared.networkStatus
        header["requestTime"] = String(Date().timeIntervalSince1970.int * 1000)

        return header
    }
}

