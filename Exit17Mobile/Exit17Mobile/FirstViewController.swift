//
//  FirstViewController.swift
//  Exit17Mobile
//
//  Created by Bradley Boutcher on 4/11/18.
//  Copyright © 2018 Bradley Boutcher. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tblVideos: UITableView!
    
    var apiKey = "AIzaSyDUph9fo0Lp45SalvRaFTLJZ8REwHPfUk0"
    
    var channelID = "UCVOfymigjL62SdOpKRFpJfg"
    
    var channelsDataArray: Dictionary<NSObject, AnyObject> = [:]
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblVideos.dataSource = self.tblVideos as? UITableViewDataSource
        tblVideos.delegate = self.tblVideos as? UITableViewDelegate
        getFeedVideos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // Fetch the video details for the tapped channel.
            getFeedVideos()
    }

    // Handle dequed cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!

        cell = tableView.dequeueReusableCell(withIdentifier: "idCellVideo", for: indexPath as IndexPath) 
        
        let videoTitle = cell.viewWithTag(11) as! UILabel
        let videoThumbnail = cell.viewWithTag(10) as! UIImageView
        
        let videoDetails = videosArray[indexPath.row]
        videoTitle.text = videoDetails["title" as NSObject] as? String
        let url = URL(string:(videoDetails["thumbnail" as NSObject] as! String))
        if let data = try? Data(contentsOf: url!)
        {
            videoThumbnail.image = UIImage(data: data)!
        }
        
        return cell
    }
    
    // Determine table length
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    // This function is useful for gathering info on a channel, maybe to be used later
    func getChannelInfo() {
        
        let parameters: Parameters = ["part": "contentDetails,snippet", "id": channelID, "key": apiKey]
        
        Alamofire.request("https://www.googleapis.com/youtube/v3/channels", parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseString { (response) -> Void in
            
            if response.response?.statusCode == 200 && response.error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: response.data!) as! Dictionary<NSObject, AnyObject>
                    
                    // Get the first dictionary item from the returned items (usually there's just one item).
                    let items: AnyObject! = resultsDict[("items") as NSObject] as AnyObject?
                    let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                    
                    // Get the snippet dictionary that contains the desired data.
                    let snippetDict = firstItemDict["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                    
                    // Create a new dictionary to store only the values we care about.
                    var desiredValuesDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                    desiredValuesDict["title" as NSObject] = snippetDict["title" as NSObject]
                    desiredValuesDict["description" as NSObject] = snippetDict["description" as NSObject]
                    desiredValuesDict["thumbnail" as NSObject] = ((snippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                    
                    // Save the channel's uploaded videos playlist ID.
                    desiredValuesDict["playlistID" as NSObject] = ((firstItemDict["contentDetails" as NSObject] as! Dictionary<NSObject, AnyObject>)["relatedPlaylists" as NSObject] as! Dictionary<NSObject, AnyObject>)["uploads" as NSObject]
                    
                    // Append the desiredValuesDict dictionary to the following array.
                    self.channelsDataArray = desiredValuesDict
                    
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
                
                // If the response is not 200, throw an error
            else {
                print("HTTP Status Code = \(String(describing: response.response?.statusCode))")
                print("Error while loading channel details: \(String(describing: response.error))")
            }
        }
    }
    
    func getFeedVideos() {
        
        let ref = Database.database().reference()
        
        // Get the selected channel's playlistID value from the channelsDataArray array and use it for fetching the proper video playlst.
        let playlistID = "UUVOfymigjL62SdOpKRFpJfg"
        
        let parameters = ["part":"snippet","playlistId":playlistID,"maxResults":"25", "key":apiKey]
        
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.response?.statusCode == 200 && response.error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    // Convert the JSON data into a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: response.data!) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items" as NSObject] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Use a loop to go through all video items.
                    for item in items {
                        let playlistSnippetDict = (item as Dictionary<NSObject, AnyObject>)["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                        
                        // Initialize a new dictionary and store the data of interest.
                        var desiredPlaylistItemDataDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistItemDataDict["title" as NSObject] = playlistSnippetDict["title" as NSObject]
                        desiredPlaylistItemDataDict["thumbnail" as NSObject] = ((playlistSnippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                        desiredPlaylistItemDataDict["videoID" as NSObject] = (playlistSnippetDict["resourceId" as NSObject] as! Dictionary<NSObject, AnyObject>)["videoId" as NSObject]
                        
                        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                        self.videosArray.append(desiredPlaylistItemDataDict)
                        print(self.videosArray)
                        
                        // Reload the tableview.
                        self.tblVideos.reloadData()
                    }
                    
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
                
                // If the response is not 200, throw an error
            else {
                print("HTTP Status Code = \(String(describing: response.response?.statusCode))")
                print("Error while loading channel details: \(String(describing: response.error))")
            }
        }
    };
}

