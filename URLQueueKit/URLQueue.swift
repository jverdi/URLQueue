//
//  URLQueue.swift
//  URLQueue
//
//  Created by Jared Verdi on 6/9/14.
//  Copyright (c) 2014 Eesel LLC. All rights reserved.
//

import Foundation
import UIKit

public class URLQueue {
    
    struct URLQueueGlobals {
        static var URLQueueKey = "URLQueueKey"
        static var URLQueueBrowserKey = "URLQueueBrowserKey"
        static var URLQueueDefaultsSuiteName = "group.com.eesel.URLQueueGroup"
    }
    
    // MARK: URLs
    
    public class func urlStrings() -> Dictionary<String,String> {
        if let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName) {
            if let encodedURLs = defaults.objectForKey(URLQueueGlobals.URLQueueKey) as? NSData {
                return NSKeyedUnarchiver.unarchiveObjectWithData(encodedURLs) as! Dictionary<String,String>
            }
            else {
                defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject([:]), forKey:URLQueueGlobals.URLQueueKey)
            }
        }
        return [:]
    }
    
    public class func addURL(url : NSURL, title : String) {
        if let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName) {
            if let encodedURLs = defaults.objectForKey(URLQueueGlobals.URLQueueKey) as? NSData {
                if let urls = NSKeyedUnarchiver.unarchiveObjectWithData(encodedURLs) as? Dictionary<String,String> {
                    var mutURLs = urls
                    if (url.absoluteString != nil) {
                        mutURLs[url.absoluteString!] = title
                        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(mutURLs), forKey:URLQueueGlobals.URLQueueKey)
                    }
                    return;
                }
            }
            
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject([url: title]), forKey:URLQueueGlobals.URLQueueKey)
        }
    }
    
    public class func saveURLs(urls : Dictionary<String,String>) {
        if let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName) {
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(urls), forKey:URLQueueGlobals.URLQueueKey)
        }
    }
    
    // MARK: Preferred Browser Settings
    
    public class func browsers() -> [String] {
        return ["Safari", "Chrome"]
    }
    
    public class func preferredBrowser() -> String {
        if let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName) {
            if let browserKey = defaults.objectForKey(URLQueueGlobals.URLQueueBrowserKey) as? String {
                return browserKey
            }
        }
        return browsers()[0];
    }
    
    public class func storePreferredBrowser(browserName: String) {
        if let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName) {
            defaults.setObject(browserName, forKey:URLQueueGlobals.URLQueueBrowserKey)
        }
    }
}