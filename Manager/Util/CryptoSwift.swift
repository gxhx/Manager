//
//  CryptoSwift.swift
//  Manager
//
//  Created by sue on 2020/6/29.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import CryptoSwift
//  MARK:  AES-ECB128解密
fileprivate let AESKey = "passwordpassword";
fileprivate let IVKey = "drowssapdrowssap";

let aesDecode = decodeAes
func decodeAes(str:String)-> String {
    //decode base64
    let data = NSData(base64Encoded: str, options:.ignoreUnknownCharacters)
    
    // byte 数组
    var encrypted: [UInt8] = []
    guard let count = data?.length else {
        return ""
    }
    
    // 把data 转成byte数组
    for i in 0..<count {
        var temp:UInt8 = 0
        data?.getBytes(&temp, range: NSRange(location: i,length:1))
        encrypted.append(temp)
    }
    
    // decode AES
    var decrypted: [UInt8] = []
    do {
        let aes = try AES(key: AESKey, iv: IVKey) // aes128
        decrypted = try aes.decrypt(encrypted)
    } catch {
        
    }
    
    // byte 转换成NSData
    let encoded = Data(decrypted)
    var str = ""
    //解密结果从data转成string
    str = String(bytes: encoded.bytes, encoding: .utf8) ?? ""
    return str
}
