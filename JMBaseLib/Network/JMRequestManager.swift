//
//  JMRequestManager.swift
//  JMBaseLib
//
//  Created by 梁建斌 on 2018/4/20.
//  Copyright © 2018年 SunlandGroup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias SuccessBlock = (_ response: Any) -> Void
typealias FailureBlock = (_ error: Error) -> Void
typealias CompleteBlock = () -> Void

public func join(_ baseUrl: String, path: String) -> String {
    return String(format: "%@%@", baseUrl, path)
}
public protocol MyParamters {
    func asDictionary() throws -> [String: Any]
}

extension Dictionary: MyParamters  {
    func setValue(_ value: Any?, for key: String) -> [String: Any] {
        var dic = self as! [String : Any]
        if value != nil {
            dic[key] = value!
        }
        return dic
    }
    
    public func asDictionary() throws -> [String: Any] { return self as! [String: Any] }
}

public class JMRequestManager: NSObject {
    @discardableResult
    func myRequest<T>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        type: T.Type,
        success: @escaping SuccessBlock = { (T) in },
        failure: @escaping FailureBlock = { (T) in },
        complete: @escaping CompleteBlock = {})
        -> DataRequest where T: Decodable {
            return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    complete()
                    switch response.result {
                    case .success(let value):
                        let decoder = JSONDecoder()
                        guard let model = try? decoder.decode(type, from: response.data!) else {
                            failure(NSError.init(domain: "com.Inspector-swift.sunland", code: -1000, userInfo: ["msg": "参数类型错误"]))
                            print("解析数据错误。value:\(value)\n url:\(url)\n paramters:\(String(describing: parameters))")
                            return
                        }
                        let result = JSON(value)
                        if result["success"].bool! {
                            print("请求成功：url: \(url)\n model: \(model)")
                            success(model)
                        }
                    case .failure(let error):
                        print("请求失败：url:\(url)\n error: \(error)\n paramters: \(String(describing: parameters))")
                        failure(error)
                    }
            }
    }
    
    @discardableResult
    func myRequestWithNoneSuccessIdentify<T>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        type: T.Type,
        success: @escaping SuccessBlock = { (T) in },
        failure: @escaping FailureBlock = { (T) in },
        complete: @escaping CompleteBlock = {})
        -> DataRequest where T: Decodable {
            return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    complete()
                    switch response.result {
                    case .success(let value):
                        let decoder = JSONDecoder()
                        guard let model = try? decoder.decode(type, from: response.data!) else {
                            failure(NSError.init(domain: "com.Inspector-swift.sunland", code: -1000, userInfo: ["msg": "参数类型错误"]))
                            print("解析数据错误：参数类型错误，value: \(value)\n url: \(url)\n paramters: \(String(describing: parameters))")
                            return
                        }
                        print("请求成功：url: \(url)")
                        success(model)
                    case .failure(let error):
                        print("请求失败：url:\(url)\n error: \(error)\n paramters: \(String(describing: parameters))")
                        failure(error)
                    }
            }
    }
    
    @discardableResult
    func myRequestWithNoneSuccessIdentifyWithUnknownObject(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        success: @escaping SuccessBlock = { (T) in },
        failure: @escaping FailureBlock = { (T) in },
        complete: @escaping CompleteBlock = {})
        -> DataRequest {
            return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    complete()
                    switch response.result {
                    case .success(let value):
                        print("请求成功：url: \(url)")
                        success(value)
                    case .failure(let error):
                        print("请求失败：url:\(url)\n error: \(error)\n paramters: \(String(describing: parameters))")
                        failure(error)
                    }
            }
    }
}
