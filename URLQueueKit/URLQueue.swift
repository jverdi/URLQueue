//
//  URLQueue.swift
//  URLQueue
//
//  Created by Jared Verdi on 6/9/14.
//  Copyright (c) 2014 Eesel LLC. All rights reserved.
//

import Foundation
import UIKit

class URLQueue {
    
    struct URLQueueGlobals {
        static var URLQueueKey = "URLQueueKey"
        static var URLQueueBrowserKey = "URLQueueBrowserKey"
        static var URLQueueDefaultsSuiteName = "group.com.eesel.URLQueueGroup"
    }
    
    // #pragma mark - URLs
    
    class func urlStrings() -> Dictionary<String,String> {
        let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName)
        if let encodedURLs = defaults.objectForKey(URLQueueGlobals.URLQueueKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(encodedURLs) as Dictionary<String,String>
        }
        else {
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject([:]), forKey:URLQueueGlobals.URLQueueKey)
            return [:]
        }
    }
    
    class func addURL(url : NSURL, title : String) {
        let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName)
        if let encodedURLs = defaults.objectForKey(URLQueueGlobals.URLQueueKey) as? NSData {
            if let urls = NSKeyedUnarchiver.unarchiveObjectWithData(encodedURLs) as? Dictionary<String,String> {
                var mutURLs = urls
                mutURLs[url.absoluteString] = title
                defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(mutURLs), forKey:URLQueueGlobals.URLQueueKey)
                return;
            }
        }
        
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject([url: title]), forKey:URLQueueGlobals.URLQueueKey)
    }
    
    class func saveURLs(urls : Dictionary<String,String>) {
        let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName)
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(urls), forKey:URLQueueGlobals.URLQueueKey)
    }
    
    // #pragma mark - Preferred Browser Settings
    
    class func browsers() -> NSString[] {
        return ["Safari", "Chrome"]
    }
    
    class func preferredBrowser() -> NSString {
        let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName)
        if let browserKey = defaults.objectForKey(URLQueueGlobals.URLQueueBrowserKey) as? NSString {
            return browserKey
        }
        return browsers()[0];
    }
    
    class func storePreferredBrowser(browserName: NSString) {
        let defaults = NSUserDefaults(suiteName: URLQueueGlobals.URLQueueDefaultsSuiteName)
        defaults.setObject(browserName, forKey:URLQueueGlobals.URLQueueBrowserKey)
    }
}