//
//  FirstViewController.swift
//  URLQueue
//
//  Created by Jared Verdi on 6/9/14.
//  Copyright (c) 2014 Eesel LLC. All rights reserved.
//

import Foundation
import UIKit
import URLQueueKit

class URLListViewController: UITableViewController {
    
    var urlQueue : Dictionary<String,String> = [:]
    var urlStrings : [String] = []
    var titles : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "reload", forControlEvents: .ValueChanged)
        
        reload()
    }
    
    func reload() {
        self.editing = false
        
        urlQueue = URLQueue.urlStrings()
        
        if urlQueue.count > 0 {
            urlStrings = Array(urlQueue.keys)
            titles = Array(urlQueue.values)
        }
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func canOpenURLInChrome(url:NSURL) -> Bool {
        return (url.scheme! == "https" || url.scheme! == "http")
            && UIApplication.sharedApplication().canOpenURL(NSURL(string:"googlechrome://")!)
    }
    
    func openURLInChrome(url:NSURL) {
        let chromeScheme = url.scheme == "https" ? "googlechromes" : "googlechrome"
        if let absoluteString = url.absoluteString {
            if let rangeForScheme = absoluteString.rangeOfString(":") {
                let urlNoScheme = absoluteString.substringFromIndex(rangeForScheme.startIndex)
                let chromeURLString = chromeScheme.stringByAppendingString(urlNoScheme)
                if let chromeURL = NSURL(string:chromeURLString) {
                    UIApplication.sharedApplication().openURL(chromeURL)
                }
            }
        }
    }
    
    func openURLInSafari(url:NSURL) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    func removeByIndexPath(indexPath: NSIndexPath) {
        urlQueue.removeValueForKey(urlStrings[indexPath.row])
        urlStrings.removeAtIndex(indexPath.row)
        titles.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        URLQueue.saveURLs(urlQueue)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlStrings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("URLCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = urlStrings[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        removeByIndexPath(indexPath)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string:urlStrings[indexPath.row])
        
        switch URLQueue.preferredBrowser() {
            case "Chrome" where canOpenURLInChrome(url!):
                openURLInChrome(url!)
            default:
                openURLInSafari(url!)
        }
        
        // remove from the queue once we open the URL
        removeByIndexPath(indexPath)
    }
}

