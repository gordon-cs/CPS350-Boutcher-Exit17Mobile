//
//  VideoTableViewController.swift
//  Exit17Mobile
//
//  Created by Bradley Boutcher on 5/10/18.
//  Copyright © 2018 Bradley Boutcher. All rights reserved.
//

import UIKit
import Alamofire

class VideoTableViewController:
UITableViewController {
    
    // MARK: Properties
    var videos = [Video]()         // Empty video array
    var apiKey = "AIzaSyDUph9fo0Lp45SalvRaFTLJZ8REwHPfUk0"  // Api key for Youtube
    var playlistID = "UUVOfymigjL62SdOpKRFpJfg"             // ID for E17 Upload Feed
    
    //Mark: Private Methods
    
    // We use this to package an array of videos, created from a JSON array
    private func loadVideos(items: Array<Dictionary<NSObject, AnyObject>>) {
        
        // Use a loop to go through all video items.
        for item in items {
            print(item)
            let playlistSnippetDict = (item as Dictionary<NSObject, AnyObject>)["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
            
            let title = playlistSnippetDict["title" as NSObject]
            let description = playlistSnippetDict["description" as NSObject]
            let thumbnail = ((playlistSnippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["medium" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
            let videoId = (playlistSnippetDict["resourceId" as NSObject] as! Dictionary<NSObject, AnyObject>)["videoId" as NSObject]
        
            // Create a new video object
            let newVideo = Video(url: thumbnail as! String, title: title as! String, description: description as! String, videoID: videoId as! String)
            
            // Append the desiredPlaylistItemDataDict dictionary to the videos array.
            videos.append(newVideo!)
        }
    }
    
    // Call the YouTube API for a list of videos
    private func getFeedVideos() {
        
        let parameters = ["part":"snippet","playlistId":playlistID,"maxResults":"25", "key":apiKey]
        
        // Make an alamofire call to get the
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.response?.statusCode == 200 && response.error == nil {
                
                do {
                    // Convert the JSON data to a dictionary
                    let resultsDict = try JSONSerialization.jsonObject(with: response.data!) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items" as NSObject] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Load our videos into an array of video objects
                    self.loadVideos(items: items)
                    
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
        self.tableView.reloadData()
        }
    };
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! VideoViewController
                controller.video = videos[indexPath.row]
            }
        }
    }
    
    // Reload data on page
    @objc func loadList(){
        //load data here
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Pull in video info
        getFeedVideos()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VideoTableViewCell else {
            fatalError("The dequed cell is not an instance of VideoTableViewCell")
        }
        
        let video = videos[indexPath.row]
        cell.videoTitle.text = video.title
        cell.thumbnail.image = video.thumbnail
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
