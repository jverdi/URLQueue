//
//  SecondViewController.swift
//  URLQueue
//
//  Created by Jared Verdi on 6/9/14.
//  Copyright (c) 2014 Eesel LLC. All rights reserved.
//

import UIKit
import URLQueueKit

class SettingsViewController: UITableViewController {
    
    var browsers = URLQueue.browsers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = false
        
        let preferredBrowser = URLQueue.preferredBrowser()
        
        for var i=0; i<browsers.count; ++i {
            if browsers[i] == preferredBrowser {
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), animated: false, scrollPosition: .None)
                return;
            }
        }
    }
    
    // #pragma mark - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return browsers.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let browser = browsers[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCellIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = browser
        
        let preferredBrowser = URLQueue.preferredBrowser()
        cell.accessoryType = browser == preferredBrowser ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let browser = browsers[indexPath.row]
        URLQueue.storePreferredBrowser(browser)
        
        for cell in tableView.visibleCells() as UITableViewCell[] {
            cell.accessoryType = .None
        }
        
        tableView.cellForRowAtIndexPath(indexPath).accessoryType = .Checkmark
    }
    
    override func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.cellForRowAtIndexPath(indexPath).accessoryType = .None
    }
}

