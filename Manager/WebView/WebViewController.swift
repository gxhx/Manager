//
//  WebViewController.swift
//  Manager
//
//  Created by sue on 2020/6/10.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift

class WebViewController: UIViewController {
    var url :URL?  {
        didSet {
            self.loadRequest()
        }
    }
    
    private lazy var progressView :UIView = {
        let view = UIView()
        var statusHeight :CGFloat = 0.0
        if #available(iOS 13.0, *) {
            statusHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }else  {
            statusHeight = UIApplication.shared.statusBarFrame.height
        }
        view.frame = CGRect(x: 0, y: statusHeight + 44, width: 0, height: 0.5)
        view.backgroundColor = UIColor(hex: "0x7D7664")
        return view
    }()
    
    lazy var webView :WebView = {
        let webView = WebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.progressBlock = {[weak self] progress in
            self?.progressView.width = (self?.view.width ?? 0.0) * CGFloat(progress)
        }
        webView.titleChangeBlock = {[weak self] title in
            self?.navigationItem.title = title
        }
        webView.loadingChangeBlock = {[weak self] isLoading in
            if isLoading {
                self?.view.makeToastActivity(.center)
                self?.progressView.isHidden = false
            }else {
                self?.view.hideToastActivity()
                self?.progressView.isHidden = true
            }
        }
        
        var statusHeight :CGFloat = 0.0
        if #available(iOS 13.0, *) {
            statusHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }else  {
            statusHeight = UIApplication.shared.statusBarFrame.height
        }
        webView.frame = CGRect(x: 0, y: statusHeight + 44, width: self.view.frame.size.width, height: self.view.frame.size.height)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        return webView
    }()
    
    lazy private var bridge : JavaScriptBridge? = {
        return JavaScriptBridge(by: self.webView, and: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.webView)
        view.addSubview(self.progressView)
        _ = self.bridge
        self.loadRequest()
    }
    
    private func loadRequest()  {
        guard self.isViewLoaded else {
            return
        }
        if #available(iOS 11.0, *) {
            let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
            for cookie in HTTPCookieStorage.shared.cookies ?? [] {
                cookieStore.setCookie(cookie, completionHandler: nil)
            }
        }
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController {
    

}

extension WebViewController :WKNavigationDelegate,WKUIDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView.makeToast("网络错误")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel) { (action) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

}
