//
//  Video.swift
//  Exit17Mobile
//
//  Container for
//  Created by Bradley Boutcher on 5/10/18.
//  Copyright © 2018 Bradley Boutcher. All rights reserved.
//

import UIKit

class Video {

    // MARK: Properties
    var thumbnail : UIImage? = nil
    var title: String
    var description: String
    var videoID: String
    
    //MARK: Initialization
    init?(url: String, title: String, description: String, videoID: String) {
        // Initialization should fail if there is no name or if the rating is negative
        if title.isEmpty || videoID.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.title = title
        self.videoID = videoID
        self.description = description
        downloadImage(url: URL(string: url)!)
    }

    // Download image (start task)
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() {
                self.thumbnail = UIImage(data: data)!
                // Reload table view
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
        }
    }
    
    // Retrieve image data from a URL
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

