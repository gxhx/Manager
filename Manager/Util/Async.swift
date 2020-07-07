//
//  Async.swift
//  Manager
//
//  Created by sue on 2020/7/7.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation

public typealias TaskBlock = () -> Void

public func async(_ task: @escaping TaskBlock) {
    _async(task)
}

public func async(_ task: @escaping TaskBlock,
           _ mainTask: @escaping TaskBlock) {
    _async(task,mainTask)
}

fileprivate func _async(_ task: @escaping TaskBlock,
                        _ mainTask: TaskBlock? = nil) {
    let item = DispatchWorkItem(block: task)
    DispatchQueue.global().async(execute: item)
    if let main = mainTask {
        item.notify(queue: .main, execute: main)
    }
}

@discardableResult
public func delay(_ seconds: Double,
           _ task: @escaping TaskBlock) -> DispatchWorkItem {
    
    let item = DispatchWorkItem(block: task)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
    return item
}

@discardableResult
public func asyncDelay(_ seconds: Double,
                _ task: @escaping TaskBlock) -> DispatchWorkItem {
    return _asyncDelay(seconds, task)
}

@discardableResult
public func asyncDelay(_ seconds: Double,
                _ task: @escaping TaskBlock,
                _ mainTask: @escaping TaskBlock) -> DispatchWorkItem {
    return _asyncDelay(seconds, task, mainTask)
}

fileprivate func _asyncDelay(_ seconds: Double,
                             _ task: @escaping TaskBlock,
                             _ mainTask: TaskBlock? = nil) -> DispatchWorkItem {
    let item = DispatchWorkItem(block: task)
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
    if let main = mainTask {
        item.notify(queue: .main, execute: main)
    }
    return item
}
