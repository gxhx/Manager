//
//  WebDemoViewController.swift
//  Manager
//
//  Created by sue on 2020/6/28.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit

class WebDemoViewController: WebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: path)
        guard let htmlPath = Bundle.main.path(forResource: "demo", ofType: "html")  else {
            return
        }
        let htmlContent = try? String(contentsOfFile: htmlPath)
        self.webView.loadHTMLString(htmlContent!, baseURL: baseUrl)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
