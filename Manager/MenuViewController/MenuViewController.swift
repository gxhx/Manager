//
//  MenuViewController.swift
//  Manager
//
//  Created by sue on 2020/5/24.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import Kingfisher
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.frame.size.height), style: .plain)
        tableView.rowHeight = 40
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuViewControllerCell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
       
        tableView.bounces = false
        return tableView
    }()
    
    lazy var headerView :MenuHeaderView = {
        let headerView = MenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 250))
        if let user = User.currentUser {
            if let url = URL(string: user.headIcon ?? user.headImageName ?? "") {
                headerView.imageView.kf.setImage(with: Source.network(url),placeholder: UIImage(named: "userphoto"))
            }
            headerView.nameLabel.text = user.nickName
            headerView.phoneLabel.text = user.phoneNum
            headerView.hotelLabel.text = user.groupName
        }
        return headerView
    }()
    
    let dataSource = ["首页","百度","扫码","jsbridgeDemo","设置","修改密码"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.width = view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuViewControllerCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            let vc = WebViewController()
            vc.url = URL(string: "http://baidu.com")
            gy_sidePushViewController(viewController: vc)
        case 2:
            let vc = QRScanViewController()
            gy_sidePushViewController(viewController: vc)
        case 3:
            let vc = WebDemoViewController()
            gy_sidePushViewController(viewController: vc)
        case 4:
            break
        case 5:
            break
        default:
            break
        }
    }
}
