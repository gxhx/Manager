//
//  MenuHeaderView.swift
//  Manager
//
//  Created by sue on 2020/6/9.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit

class MenuHeaderView: UIView {
    
    lazy var imageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(hex: "0x171717")
        imageView.image = R.image.userphoto()
        return imageView
    }()
    
    lazy var nameLabel :UILabel = {
        let label = UILabel()
        label.text = "花名"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hex: "0x999999")
        return label
    }()
    
    lazy var phoneLabel :UILabel = {
        let label = UILabel()
        label.text = "手机号"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hex: "0xABABAB")
        return label
    }()
    
    
    lazy var hotelLabel :UILabel = {
        let label = UILabel()
        label.text = "酒店"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hex: "0x999999")
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        backgroundColor = UIColor(hex: "0x171717")
        addSubview(self.imageView)
        addSubview(self.nameLabel)
        addSubview(self.phoneLabel)
        addSubview(self.hotelLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo((50))
            make.centerX.equalTo(self)
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp_bottomMargin).offset(10)
            make.height.equalTo(20)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(10)
            make.height.equalTo(20)
        }
        
        hotelLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalTo(phoneLabel.snp_bottomMargin).offset(10)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
