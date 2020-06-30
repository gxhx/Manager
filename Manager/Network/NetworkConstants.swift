//
//  NetworkConstants.swift
//  Manager
//
//  Created by sue on 2020/6/5.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import Moya
import NVActivityIndicatorView


public let httpParameters : [String : Any] = {
    
    var parameters : [String : Any] = [:]
    parameters["platType"] = 200
    parameters["appVer"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    parameters["channelId"] = 20001
    return parameters
}()

private let httpHeader : [String : String] = {
    
    var parameters : [String : String] = [:]
    parameters["platType"] = "200"
    parameters["appVer"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    parameters["channelId"] = "20001"
    return parameters
}()

public func getHttpHeader() -> [String : String] {
    var header = httpHeader
    header["token"] = ""
    return httpHeader;
}

public enum httpServiceApi {
    case book
    case feed
    case web
    
    public func httpBaseUrl() -> String {
        switch self {
        case .book:
            #if DEBUG
                return "http://test.book.sharlockk.com/"
            #else
                return "http://book.sharlockk.com/"
            #endif
        case .feed:
            #if DEBUG
                return "http://test.feeds.sharlockk.com/"
            #else
                return "http://feeds.sharlockk.com/"
            #endif
        case .web:
            #if DEBUG
                return "http://h5.sharlockk.com/"
            #else
                return "http://h5.sharlockk.com/"
            #endif
        }
    }
}

let RESULT_CODE = "code"
let RESULT_MESSAGE = "msg"
let RESULT_DATA = "data"
let RESULT_RESULT = "result"

enum RequestError : Error{
    case noCodeKey
    case noDataKey
    case sysError(statusCode:String,errorMsg:String?)
    var errMsg : String {
        get {
            switch self {
            case .noCodeKey:
                return "状态码错误"
            case .noDataKey:
                return "数据解析失败"
            case .sysError(let code ,let errorMsg):
                if (code == "999"){
                    return "登录状态失效"
                }
                return "\(errorMsg ?? "服务端异常")"
            }
        }
    }
}

enum StatusCode :Int {
    case success = 0
    case tokenInvalid = 999
}

/// loading plugin
let networkActivityPlugin = NetworkActivityPlugin {(type, target) in
    
    DispatchQueue.main.async {
        let activityData = ActivityData(type:.ballRotateChase,backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2))
        switch type {
        case .began:
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        case .ended:
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
}

class CookiesPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        var cookies = ""
        for cookie in HTTPCookieStorage.shared.cookies ?? [] {
            cookies.append(contentsOf: "\(cookie.name)=\(cookie.value)")
        }
        request.addValue(cookies, forHTTPHeaderField: "Cookie")
        return request
    }

}

let NetworkPlugins : [PluginType] = [networkActivityPlugin,CookiesPlugin(),NetworkLoggerPlugin()]
/// sampleData
let stubAction: (_ type: TargetType) -> Moya.StubBehavior  = { type in
    return .delayed(seconds: 5)
}


