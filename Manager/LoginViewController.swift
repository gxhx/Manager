//
//  LoginViewController.swift
//  Manager
//
//  Created by sue on 2020/6/5.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SnapKit


class LoginViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    
    lazy var backImageView : UIImageView = {
        let imageView = UIImageView(image: R.image.loginBack())
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        return imageView
    }()
    
    lazy var phoneTextFeild : LeftViewPadingTextField = {
        let textField = LeftViewPadingTextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.placeholder = "手机号/会员卡号"
        textField.keyboardType = .numberPad
        let imageView = UIImageView(image: R.image.loginPhone())
        textField.leftView = imageView
        textField.leftViewMode = .always
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextFeild : LeftViewPadingTextField = {
        let textField = LeftViewPadingTextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.placeholder = "密码"
        textField.returnKeyType = .done
        textField.delegate = self
        let imageView = UIImageView(image: R.image.loginPassword())
        textField.leftView = imageView
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hex: "#F4CF9B");
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
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

extension LoginViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension LoginViewController {
    func setupAction() {
        loginBtn.rx.tap.subscribe(onNext :{[weak self] in
            self?.loginAction()
        }).disposed(by: disposeBag)
    }
    
    func loginAction() {
        guard let phoneNumber = phoneTextFeild.text, let password = passwordTextFeild.text else {
            view.makeToast("请输入账号密码")
            return
        }
    
        let provide = MoyaProvider<LoginService>(stubClosure: stubAction, plugins: NetworkPlugins)
        provide.rx.request(.login(phoneNumber, password), callbackQueue: DispatchQueue.main).map(User.self).asObservable().subscribe(onNext:{[weak self](user) in
            print(user)
            User.currentUser = user
            self?.dismiss(animated: true, completion: nil)
        },onError: { [weak self] error in
            print(error)
            if let error1 = error as? RequestError {
                self?.view.makeToast("\(error1.errMsg)")
            }else {
                self?.view.makeToast("网络错误")
            }
        }).disposed(by: disposeBag)
        
        
    }
}

extension LoginViewController {
    func setupView() {
        view.addSubview(backImageView)
        view.addSubview(phoneTextFeild)
        view.addSubview(passwordTextFeild)
        view.addSubview(loginBtn)
        phoneTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(120)
            make.height.equalTo(48)
        }
        
        passwordTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(phoneTextFeild.snp_bottomMargin).offset(20)
            make.height.equalTo(48)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(passwordTextFeild.snp_bottomMargin).offset(20)
            make.height.equalTo(48)
        }
    }
}

extension LoginViewController :UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === phoneTextFeild {
            passwordTextFeild.becomeFirstResponder()
        }else {
            passwordTextFeild.resignFirstResponder()
        }
        return true
    }
}
