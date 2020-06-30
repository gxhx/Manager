//
//  PrimitiveSequence + Extension.swift
//  Manager
//
//  Created by sue on 2020/6/6.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import SwiftyJSON


extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func map<T: ImmutableMappable>(_ type: T.Type) -> PrimitiveSequence<Trait, T> {
        return self.map { (response) -> T in
            let json = try JSON(data: response.data)
            guard let code = json[RESULT_CODE].int else {
                throw RequestError.noCodeKey
            }
            if code != StatusCode.success.rawValue {
                throw RequestError.sysError(statusCode:"\(code)" , errorMsg: json[RESULT_MESSAGE].string)
            }
            if let data = json[RESULT_DATA].dictionaryObject {
                return try Mapper<T>().map(JSON: data)
            }else if let data = json[RESULT_RESULT].dictionaryObject {
                return try Mapper<T>().map(JSON: data)
            }
            throw RequestError.noDataKey
        }.do(onSuccess: { (_) in
            
        }, onError: { (error) in
            print(error)
        })
    }
    
    func map<T: Mappable>(_ type: T.Type) -> PrimitiveSequence<Trait, T> {
        return self.map { (response) -> T in
            let json = try JSON(data: response.data)
            guard let code = json[RESULT_CODE].int else {
                throw RequestError.noCodeKey
            }
            if code != StatusCode.success.rawValue {
                throw RequestError.sysError(statusCode:"\(code)" , errorMsg: json[RESULT_MESSAGE].string)
            }
            if let data = json[RESULT_DATA].dictionaryObject, let t = Mapper<T>().map(JSON: data){
                return  t
            }else if let data = json[RESULT_RESULT].dictionaryObject, let t = Mapper<T>().map(JSON: data) {
                return  t
            }
            throw RequestError.noDataKey
        }.do(onSuccess: { (_) in
            
        }, onError: { (error) in
            print(error)
        })
    }
}
