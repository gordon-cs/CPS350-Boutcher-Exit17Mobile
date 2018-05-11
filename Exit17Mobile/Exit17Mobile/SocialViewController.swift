//
//  SocialViewController.swift
//  Exit17Mobile
//
//  Created by Bradley Boutcher on 5/11/18.
//  Copyright © 2018 Bradley Boutcher. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController{
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    @IBAction func openTwitter(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://twitter.com/exit17live")!, options: [:], completionHandler: { (status) in
            
        })

    }
    @IBAction func openInsta(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.instagram.com/exit17live/")!, options: [:], completionHandler: { (status) in
            
        })
    }
}
    

