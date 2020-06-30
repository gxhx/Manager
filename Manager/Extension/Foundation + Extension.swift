//
//  Foundation + Extension.swift
//  Manager
//
//  Created by sue on 2020/6/28.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

extension Array {
    /// 扩展 安全下标返回
    /// - Returns: 超出范围返回nil
    subscript(safe idx:Int) -> Element? {
        if (startIndex..<endIndex).contains(idx) {
            return self[idx]
        }
        return nil
    }
}

extension BinaryInteger {
    
    /// 扩展 判断是否为奇数
    /// - Returns: bool
    func isOdd() -> Bool { return self % 2 == 0 }
}
