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
            
            print("got search")
            //print("\(tabBarController?.viewControllers?[1])")
            // Configure the searches tab
            setUpSearchesTab()
            
           /* if let searchTVC = (self.tabBarController?.viewControllers?[1].contents as? SearchTableViewController)
            {
                print("configuring searches")
                searchTVC.search = searchText
                tabBarController?.viewControllers?[1] = searchTVC
            }*/

            if searchTextField != nil
            {
                searchTextField.resignFirstResponder()
            }
             tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    var shouldEditTextField : Bool = true
    
    //Implementation of internal functions
    
    private func setUpSearchesTab()
    {
        let searchTVC : SearchTableViewController?
        
        if let navCon = self.tabBarController?.viewControllers?[1] as? UINavigationController
        {
            searchTVC = navCon.visibleViewController as? SearchTableViewController
            searchTVC?.search = searchText
          //  print(searchTVC?.searches)
            navCon.viewControllers = [searchTVC!]
            self.tabBarController?.viewControllers?[1] = navCon
        }
        
    }
    
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
            searchTextField.text = searchText
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelected = indexPath
        performSegue(withIdentifier: "ShowMentions", sender: self)
    }
    
    private var indexPathSelected : IndexPath = IndexPath()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination
        
        if let mentionsTableViewController = dvc as? MentionsTableViewController
        {
            if segue.identifier == "ShowMentions"
            {
                mentionsTableViewController.tweet = tweets[indexPathSelected.section][indexPathSelected.row]
            }
        }
    }
}


