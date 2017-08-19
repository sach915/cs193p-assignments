//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Sach Vaidya on 8/17/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate  {
    
    //Model
    private var tweets = [Array<Twitter.Tweet>]()
    {
        didSet{
            //print(tweets)
        }
    }
    var searchText : String?
    {
        didSet{
            searchTextField?.text = searchText
            //removes keyboard on search
            searchTextField.resignFirstResponder()
             tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    //Implementation of internal functions
    
    private func twitterRequest() -> Twitter.Request?{
        if let query = searchText, !query.isEmpty{
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest : Twitter.Request?
    
    private func searchForTweets(){
        if let request = twitterRequest(){
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest{
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                        //above updates UI, will call necessary functions to update itself
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBOutlet weak var searchTextField: UITextField!
    // MARK: - Table view data source
    {
        didSet{
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField{
            searchText = searchTextField.text
        }
        return true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        // Configure the cell...  
        
        let tweet:Tweet = tweets[indexPath.section][indexPath.row]
        //cell.textLabel!.text = tweet.text
        //cell.detailTextLabel!.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell{
            tweetCell.tweet = tweet
        }

        return cell
    }
    

    

}
