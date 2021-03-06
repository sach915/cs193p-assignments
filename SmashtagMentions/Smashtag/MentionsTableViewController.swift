//
//  MentionsTableViewController.swift
//  SmashtagMentions
//
//  Created by Sach Vaidya on 8/19/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    
    //MODEL
    var tweet : Twitter.Tweet?
        {
        didSet{
            let images = (tweet?.media)!
            let hashtags = (tweet?.hashtags)!
            let urls = (tweet?.urls)!
            let users = (tweet?.userMentions)!
            
            tweetData.append(TweetData.mediaItem(images))
            tweetData.append(TweetData.mention(hashtags))
            tweetData.append(TweetData.mention(urls))
            tweetData.append(TweetData.mention(users))
        }
    }
    
    private var tweetData = [TweetData]()
    private var sectionToSectionHeader : Dictionary<Int,String> = [0:"Images", 1:"Hashtags", 2:"Urls", 3:"Users"]
    
    private enum TweetData
    {
        case mention([Mention])
        case mediaItem([MediaItem])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweetData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tweetData[section]
        {
        case .mention(let mention):
            return mention.count
        case .mediaItem(let mediaItem):
            return mediaItem.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let header = sectionToSectionHeader[indexPath.section]
        {
            switch(header)
            {
            case "Images":
                    return 300
            default:
                return 30
            }
        }
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier:String = " "
        switch indexPath.section
        {
        case 0:
            identifier = "MentionImage"
        default:
            identifier = "MentionText"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        // Configure the cell...
        
        switch identifier
        {
        case "MentionImage":
            switch tweetData[indexPath.section]
            {
            case .mediaItem(let mediaItem):
                let mediaForRow = mediaItem[indexPath.row]
                if let tweetImageCell = cell as? TweetImageTableViewCell
                {
                    tweetImageCell.imageURL = mediaForRow.url
                    tweetImageCell.aspectRatio = mediaForRow.aspectRatio
                }
        
            default:
                break
            }
        case "MentionText":
            switch tweetData[indexPath.section] {
            case .mention(let mention):
                let mentionForRow = mention[indexPath.row]
                cell.textLabel?.text = mentionForRow.keyword
            default:
                break
            }
        default:
            break
            
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tweetData[section]
        {
        case .mention(let mention):
            if mention.count > 0
            {
                return sectionToSectionHeader[section]
            }
        case .mediaItem(let mediaItem):
            if mediaItem.count > 0
            {
                return sectionToSectionHeader[section]
            }
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let header = sectionToSectionHeader[indexPath.section]
        {
            let cell = tableView.cellForRow(at: indexPath)
            switch header{
            case "Images":
                if let tweetImageCell = cell as? TweetImageTableViewCell
                {
                    imageClicked = tweetImageCell.tweetImage
                }
               // print("WillPerform")
                performSegue(withIdentifier: "ShowImage", sender: self)
            case "Users","Hashtags":
                newSearchText = cell?.textLabel?.text
                performSegue(withIdentifier: "Show Tweets with Identifier", sender: self)
            case "Urls":
                let url : URL?
                if let urlString = cell?.textLabel?.text
                {
                    url = URL(string: urlString)
                    UIApplication.shared.open(url!)
                }
            default:
                break
            }
            
        }
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    private var imageClicked : UIImage?
    private var newSearchText : String?
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let dvc = segue.destination
        switch segue.identifier!
        {
            case "ShowImage":
                if let imageScrollVC = dvc as? ImageScrollViewController
                {
                    if imageClicked != nil
                    {
                        imageScrollVC.image = imageClicked
                    }
                }
            case "Show Tweets with Identifier":
                if let tweetTVC = dvc as? TweetTableViewController
                {
                    if newSearchText != nil{
                        tweetTVC.searchText = newSearchText
                        tweetTVC.shouldEditTextField = false
                    }
                }
            default:
                break
        }
     }
    
    
}
