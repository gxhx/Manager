//
//  Util.swift
//  Manager
//
//  Created by sue on 2020/7/7.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation

/// Curry
//prefix func ~<A, B ,C>(_ fn: @escaping (A, B) -> C) -> (A) -> (B) -> (C) {
//    {A in {B in fn(A, B)}}
//}
//
//prefix func ~<A, B ,C, D>(_ fn: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> (D) {
//    {A in {B in {C in fn(A, B, C)}}}
//}
//
//prefix func ~<A, B ,C, D, E>(_ fn: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> (E) {
//    {A in {B in {C in {D in fn(A, B, C, D)}}}}
//}
//


//struct Timer {
//
//    private static var timers = [String:DispatchSourceTimer]()
//    private let semaphore  = DispatchSemaphore(value: 1)
//
//}

extension Timer {
    
    private static var timers = [String:DispatchSourceTimer]()
    private static let semaphore  = DispatchSemaphore(value: 1)
      
   static func execTask(_ task: @escaping()->(),_ deadline: TimeInterval,_ interval: TimeInterval,_ repeats: Bool,_ async: Bool) -> String? {
        guard deadline > 0, !(interval <= 0 && repeats) else {
            return nil
        }
        
        let queue = async ? DispatchQueue.global() : DispatchQueue.main
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        timer.schedule(deadline: DispatchTime.now() + deadline, repeating: interval, leeway: .milliseconds(10))
    
        timer.setEventHandler {
            task()
            if !repeats {
                timer.cancel()
            }
        }
        semaphore.wait()
        let name = "\(Self.timers.count)"
        timers[name] = timer
        semaphore.signal()
        timer.resume()
        return name
    }
    
    
    static func execTask(_ target: AnyObject,_ selector: Selector,_ deadline: TimeInterval,_ interval: TimeInterval,_ repeats: Bool,_ async: Bool ) -> String? {
        return Self.execTask({
            if target.responds(to: selector) {
                 let _ = target.perform(selector)
            }
        }, deadline, interval, repeats, async)
        
    }
    
    static func cancelTask(name: String?) {
        
        guard let name = name else {
            return
        }
        
        semaphore.wait()
        if let timer = timers[name] {
            timer.cancel()
            timers.removeValue(forKey: name)
        }
        semaphore.signal()
    }
    
}
