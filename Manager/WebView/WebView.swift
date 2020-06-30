//
//  WebView.swift
//  Manager
//
//  Created by sue on 2020/6/10.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import WebKit
class WebView: WKWebView {
    var progressBlock :((Double)->())?
    var loadingChangeBlock :((Bool)->())?
    var titleChangeBlock : ((String?)->())?
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress")
        self.removeObserver(self, forKeyPath: "loading")
        self.removeObserver(self, forKeyPath: "title")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? WebView == self, let keyPath = keyPath {
            if keyPath == "estimatedProgress" {
                progressBlock?(estimatedProgress)
            }else if keyPath == "loading" {
                loadingChangeBlock?(isLoading)
            }else if keyPath == "title" {
                titleChangeBlock?(title)
            }
        }
    }
}
