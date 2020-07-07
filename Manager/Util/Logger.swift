//
//  Logger.swift
//  Manager
//
//  Created by sue on 2020/7/7.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 8*3600)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


func logger(_ msg: Any...,
    time: Date = Date(),
    file: NSString = #file,
    line: Int = #line,
    fn: String = #function,
    thread: Thread = Thread.current) {
    #if DEBUG
    let prefix = "\(time.iso8601) \(file.lastPathComponent)[\(line)] \(fn): \(thread)"
    print(prefix,msg)
    #endif
}

