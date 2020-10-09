//
//  CacheManager.swift
//  Manager
//
//  Created by sue on 2020/6/8.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
/// Disk cache
public struct CacheManager {
    
    static let share = CacheManager()
    private let fileManager = FileManager()
    private let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/ManagerCache/"
    /// 读写队列 使用.barrier   多读单写
    private let queue = DispatchQueue(label: "com.Sharlockk.disk-cache",attributes: .concurrent)

    private init() {
        var isDirectory : ObjCBool = false
        guard fileManager.fileExists(atPath: docPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            
            try? fileManager.createDirectory(at: URL(fileURLWithPath: docPath, isDirectory: true), withIntermediateDirectories: true, attributes: nil)
            
            return
        }
    }
    
    /// Returns the value associated with a given key.
    /// - Parameter key: key A string identifying the value.
    /// - Returns: The value associated with key, or nil if no value is associated with key.
    public func getObject<T: NSObject & NSSecureCoding>(withKey key:String)  -> T?{
        let filePath = self.pathForKey(key)
      
        guard fileManager.fileExists(atPath: filePath) else{
            return nil
        }
        var t : T? = nil
        if let data = fileManager.contents(atPath: filePath) {
            if #available(iOS 11.0, *) {
                t = try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
            }else {
                t = NSKeyedUnarchiver.unarchiveObject(with: data) as? T
            }
        }
        
        return t;
    }
    
    
    /// Returns the value associated with a given key.
    /// This method returns immediately and invoke the passed block in background queue
    /// when the operation finished.
    /// - Parameters:
    ///   - key: key A string identifying the value.
    ///   - completion: block A block which will be invoked in background queue when finished.
    /// - Returns: Void
    public func getObject<T: NSObject & NSSecureCoding>(withKey key:String,_ completion:@escaping ((T?)->())) {
        queue.async {
            let item :T?  = self.getObject(withKey: key)
            completion(item)
        }
    }
    
    
    /// Sets the value of the specified key in the cache.
    /// This method may blocks the calling thread until file write finished.
    /// - Parameters:
    ///   - key: key    The key with which to associate the value. If nil, this method has no effect.
    ///   - object: object The object to be stored in the cache. If nil, it calls `removeObjectForPath:`.
    /// - Returns:
    public func save(withKey key: String,_ object: Any?)  {
        
        let filePath = self.pathForKey(key)
        if object == nil {
            self.removeObjectForPath(by: filePath)
            return
        }
        
        if #available(iOS 11.0, *) {
            
            let data = try? NSKeyedArchiver.archivedData(withRootObject: object!, requiringSecureCoding: true)
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            
        }else {
            NSKeyedArchiver.archiveRootObject(object!, toFile: filePath)
        }
        
    }
    
    /// Sets the value of the specified key in the cache.
    /// This method returns immediately and invoke the passed block in background queue
    /// when the operation finished.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - object: The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
    ///   - completion: A block which will be invoked in background queue when finished.
    public func save(withKey key: String,_ object: Any?,_ completion:@escaping ()->()) {
        queue.async(group: nil, qos: .default, flags: .barrier) {
            self.save(withKey: key, object)
            completion()
        }
    }

    private func pathForKey(_ key: String) -> String {
        return (docPath as NSString).appendingPathComponent(key)
    }
    
    private func removeObjectForPath(by path:String) {
        guard fileManager.fileExists(atPath: path) else {
            return
        }
        queue.async(group: nil, qos: .default, flags: .barrier) {
            try? self.fileManager.removeItem(atPath: path)
        }
    }
    
    public func removeAll() {
        queue.async(group: nil, qos: .default, flags: .barrier) {
            try? self.fileManager.removeItem(atPath: self.docPath)
            try? self.fileManager.createDirectory(at: URL(fileURLWithPath: self.docPath, isDirectory: true), withIntermediateDirectories: true, attributes: nil)
        }
    }
}
