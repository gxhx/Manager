//
//  LoginService.swift
//  Manager
//
//  Created by sue on 2020/6/5.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
public enum LoginService {
    case login(_ phoneNum:String,_ passWord:String)
    case logout
}

extension LoginService :TargetType {
    
    public var sampleData: Data {
        return "{\"code\":0,\"msg\":\"成功\",\"result\":{\"phoneNum\":\"18888888888\",\"uid\":1,\"nickName\":\"Sharlockk\"}}".data(using: String.Encoding.utf8)!
    }
    
    public var baseURL: URL {
        return URL(string: httpServiceApi.book.httpBaseUrl())!
    }
    
    public var path: String {
        switch self {
        case .login(_, _):
            return "userManager/adminLogin.do"
        case .logout:
            return "admin_logout.cgi"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        var param:[String:Any] = httpParameters
        switch self {
        case .login(let phoneNum, let passWord):
            param["phoneNum"] = phoneNum
            param["passWord"] = passWord
        default:
            return .requestPlain
        }
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }

    public  var headers: [String : String]? {
        return getHttpHeader()
    }
}

