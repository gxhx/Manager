//
//  JavaScriptBridge.swift
//  Manager
//
//  Created by sue on 2020/6/12.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import WebKit
fileprivate  let  kBridgePrefix = "jsbridge"
class JavaScriptBridge: NSObject, WKScriptMessageHandler {

    fileprivate(set)  weak var h5ViewController : UIViewController?
    fileprivate(set) weak var wkWebView : WKWebView?
    private  var _handleDictionary : [String : JavaScriptProtocol] = [:]
    private static var _userScript :WKUserScript?
    init?(by webView:WKWebView,and viewController:UIViewController) {
        self.h5ViewController = viewController
        self.wkWebView = webView
        super.init()
        self.addScriptMessageHandler()
        self.addInjectJavascriptFile()
    }
    
    deinit {
        removeScriptMessageHandler()
    }
    
    func addInjectJavascriptFile() {
        if let userScript = Self._userScript {
            wkWebView?.configuration.userContentController.addUserScript(userScript)
            return
        }
        if let path = Bundle.main.path(forResource: "injectJavascriptFile", ofType: "js"),let source = try? String(data: Data(contentsOf: URL(fileURLWithPath: path)), encoding: .utf8) {
            let s = aesDecode(source)
            let userScript = WKUserScript(source: s, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            Self._userScript = userScript
            wkWebView?.configuration.userContentController.addUserScript(userScript)
        }
    }
    
    func addScriptMessageHandler()  {
        let delegate = JavaScriptBridgeDelegate(self)
        wkWebView?.configuration.userContentController.add(delegate, name: kBridgePrefix)
    }
    
    func removeScriptMessageHandler() {
        wkWebView?.configuration.userContentController.removeAllUserScripts()
        wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: kBridgePrefix)
    }
       
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard message.name == kBridgePrefix else {
            return
        }
        let adapter : JavaScriptMessageAdapter
        do {
            adapter = try JavaScriptMessageAdapter(message.body as? [String : Any])
        } catch let error as JavaScriptError  {
            self.dispatchMessage(["errmsg":error.errMsg])
            return
        } catch {
            self.dispatchMessage(["errmsg":"no reasons"])
            return
        }
        
        if let instance = _handleDictionary[adapter.moduleName] {
            instance.perform(adapter.selector,with: adapter,afterDelay: 0)
        }else {
            let instance = adapter.moduleClass.init(bridge: self)
            _handleDictionary[adapter.moduleName] = instance
            instance.perform(adapter.selector,with: adapter,afterDelay: 0)
        }
    }
    
    public func dispatchMessage(_ dictionary:Dictionary<String, Any>) {
        var messageJson = ""
        do {
           messageJson = try String(data: JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0)), encoding: .utf8) ?? ""
            
        } catch  {
            
        }
        let command = "jsbridge._handleMessageFromObjC(\(messageJson));"
        if Thread.current.isMainThread {
            wkWebView?.evaluateJavaScript(command, completionHandler: nil)
        }else {
            DispatchQueue.main.sync {
                wkWebView?.evaluateJavaScript(command, completionHandler: nil)
            }
        }
    }
    
}

