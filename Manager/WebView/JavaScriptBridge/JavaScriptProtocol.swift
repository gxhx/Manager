//
//  JavaScriptProtocol.swift
//  Manager
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation

protocol JavaScriptProtocol: NSObject {
    var bridge : JavaScriptBridge? {set get}
}

extension JavaScriptProtocol {
    
    init(bridge: JavaScriptBridge) {
        self.init()
        self.bridge = bridge
    }
    
    func success(_ messageId: String,_ params: [String : Any]?) {
        self.bridge?.dispatchMessage(["callbackId": messageId,"code": 0,"data": params ?? []])
    }
    func fail(_ messageId: String,_ errMsg: String) {
        self.bridge?.dispatchMessage(["callbackId": messageId,"code": -1,"data":["msg": errMsg]])
    }
}


enum JavaScriptError: Error{
    case bodyError
    case callIdError
    case moduleError
    case actionError
    
    var errMsg : String {
        get {
            switch self {
            case .bodyError:
                return "message body need json format"
            case .callIdError:
                return "callId miss"
            case .moduleError:
                return "not found moudle"
            case .actionError:
                return "not response to this action"
            }
        }
    }
}



class TestObject: NSObject, JavaScriptProtocol {

    weak var bridge: JavaScriptBridge?
    @objc func test(_ msg: JavaScriptMessageAdapter) {
        print(msg.callId)
        self.success(msg.callId,["ok":222])
    }
    
    @objc func testFail(_ msg: JavaScriptMessageAdapter) {
        print(msg.callId)
        self.fail(msg.callId, "fail")
    }
    
}
