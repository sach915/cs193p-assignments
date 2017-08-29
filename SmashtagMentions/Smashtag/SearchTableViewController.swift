//
//  SearchTableViewController.swift
//  SmashtagMentions
//
//  Created by Sach Vaidya on 8/28/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    //MODEL
    var search : String?
    {
        didSet{
            searches.insert(search!, at: 0)
        }
    }
    
    private var searches = [String]()
    {
        didSet{
            if searches.count > 100
            {
                searches.removeLast()
                print("Removed")
                tableView.reloadData()
            }
            else{
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath] , with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cellWithInfo = cell
        {
            previousSearchToFetchTweetsFor = cellWithInfo.textLabel?.text
        }
        performSegue(withIdentifier: "Show Tweets for Previous Search", sender: self)
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Show Search", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = searches[indexPath.row]

        return cell
    }
    

    // MARK: - Navigation
    private var previousSearchToFetchTweetsFor : String?
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let dvc = segue.destination
       
        if segue.identifier == "Show Tweets for Previous Search"
        {
            if let tweetTVC = dvc as? TweetTableViewController
            {
                tweetTVC.searchText = previousSearchToFetchTweetsFor
            }
        }
    }
    

}
