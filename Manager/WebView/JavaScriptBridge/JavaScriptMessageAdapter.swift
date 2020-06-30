//
//  JavaScriptMessageAdapter.swift
//  Manager
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import ObjectiveC.runtime
class JavaScriptMessageAdapter: NSObject {
    
    fileprivate(set) var callId :String
    fileprivate(set) var moduleName :String
    fileprivate(set) var moduleClass :JavaScriptProtocol.Type
    fileprivate(set) var selectorName :String
    fileprivate(set) var selector :Selector
    fileprivate(set) var parameters :[String : Any]?
    
    private static var modulesMap :[String :JavaScriptProtocol.Type] = [:]
    
    /// 初始化message
    /// - Parameter message: Example {"callId":1,"module":"module1","action":"back","data":{"arg1":"value1"}}
    ///
    init(_ message: [String: Any]?) throws {
        
        guard let dict = message else {
            throw JavaScriptError.bodyError
        }
        
        guard let callId = dict["callId"] else {
            throw JavaScriptError.callIdError
        }
        self.callId = "\(callId)"
        
        
        guard let module = dict["module"] as? String else {
            throw JavaScriptError.moduleError
        }
        
        self.moduleName = module
        
        guard let moduleClass = Self.modulesMap[module] else  {
            throw JavaScriptError.moduleError
        }
        
        self.moduleClass = moduleClass
        
        guard let selectorName = dict["action"] as? String else {
            throw JavaScriptError.actionError
        }
        
        self.selectorName = "\(selectorName):"
        let selector = Selector(self.selectorName)
        guard moduleClass.instancesRespond(to: selector) else {
            throw JavaScriptError.actionError
        }
        self.selector = selector
        
        if let json = dict["data"] as? [String: Any] {
            self.parameters = json
        }
    }
    
    
    static func registModules(module:String,moduleClass:JavaScriptProtocol.Type){
        modulesMap[module] = moduleClass
    }
}
