//
//  UIColor + Extension.swift
//  Manager
//
//  Created by sue on 2020/6/5.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(hex:String){

        // 1.将字符串转成大写
        var tempHex = hex.uppercased()
        
        // 2.判断开头: 0X/#/##
        if tempHex.hasPrefix("0X") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        // 3.判断字符串的长度是否符合
        //         RGB                  RGBA                     RRGGBB              RRGGBBAA
        guard tempHex.count == 3 || tempHex.count == 4 || tempHex.count == 6 || tempHex.count == 8 else {
            return nil
        }
        var r : UInt64 = 0, g : UInt64 = 0, b : UInt64 = 0, alpha : UInt64 = 1
        
        // 4.分别取出RGBA
        if tempHex.count < 5 {
            var range = NSRange(location: 0, length: 1)
            let rHex = (tempHex as NSString).substring(with: range)
            Scanner(string: rHex).scanHexInt64(&r)
            
            range.location = 1
            let gHex = (tempHex as NSString).substring(with: range)
            Scanner(string: gHex).scanHexInt64(&g)
            
            range.location = 2
            let bHex = (tempHex as NSString).substring(with: range)
            Scanner(string: bHex).scanHexInt64(&b)
            
            if tempHex.count == 4 {
                range.location = 3
                let alphaHex = (tempHex as NSString).substring(with: range)
                Scanner(string: alphaHex).scanHexInt64(&alpha)
            }else {
                alpha = 1
            }
           
        }else {
            var range = NSRange(location: 0, length: 2)
            let rHex = (tempHex as NSString).substring(with: range)
            Scanner(string: rHex).scanHexInt64(&r)
            
            range.location = 2
            let gHex = (tempHex as NSString).substring(with: range)
            Scanner(string: gHex).scanHexInt64(&g)
            
            range.location = 4
            let bHex = (tempHex as NSString).substring(with: range)
            Scanner(string: bHex).scanHexInt64(&b)
            
            if tempHex.count == 8 {
                range.location = 6
                let alphaHex = (tempHex as NSString).substring(with: range)
                Scanner(string: alphaHex).scanHexInt64(&alpha)
            }else {
                alpha = 1
            }
        }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
}
