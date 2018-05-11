//
//  VideoViewController.swift
//  Exit17Mobile
//
//  Created by Bradley Boutcher on 5/11/18.
//  Copyright © 2018 Bradley Boutcher. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import WebKit

class VideoViewController: UIViewController{
    @IBOutlet var webView: WKWebView!
    
    var video: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://www.youtube.com/embed/" + (video?.videoID)!)
        let request = NSURLRequest(url: url! as URL)
        
        webView.load(request as URLRequest)
        if webView.isLoading {
            print("loading...")
        }
    }

    
}
