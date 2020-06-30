//
//  JavaScriptBridgeDelegate.swift
//  Manager
//
//  Created by sue on 2020/6/12.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import WebKit
class JavaScriptBridgeDelegate: NSObject,WKScriptMessageHandler {

    weak fileprivate(set) var delegate : WKScriptMessageHandler?
    init(_ delegate:WKScriptMessageHandler) {
        self.delegate = delegate
    }
    private override init() {
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
