//
//  ShareViewController.swift
//  URLQueueExtension
//
//  Created by Jared Verdi on 6/9/14.
//  Copyright (c) 2014 Eesel LLC. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import URLQueueKit

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        
        if let inputItems : NSExtensionItem[] = self.extensionContext.inputItems as? NSExtensionItem[] {
            for item : NSExtensionItem in inputItems {
                if let attachments = item.attachments as? NSItemProvider[] {
                    
                    if attachments.isEmpty {
                        self.extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
                        return
                    }
                    
                    attachments[0].loadItemForTypeIdentifier(kUTTypeURL, options:nil, completionHandler: {
                        obj, error in
                        if error {
                            println("Unable to add as a URL")
                        }
                        else if let url = obj as? NSURL {
                            URLQueue.addURL(url, title:self.textView.text)
                        }
                        self.extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
                    })
                }
            }
        }
    }
}
