//
//  ViewController.swift
//  Manager
//
//  Created by sue on 2020/5/22.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import GYSide
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "userIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction))
        navigationItem.title = "首页"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        guard let _ = User.currentUser else {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
            return
        }
    }
    
    @objc func menuAction()  {
        
        JavaScriptMessageAdapter.registModules(module: "", moduleClass: TestObject.self)
        
        let vc = MenuViewController.init()
        gy_showSide(configuration: { (config) in
            
        }, viewController: vc)
        
    }
    
}

