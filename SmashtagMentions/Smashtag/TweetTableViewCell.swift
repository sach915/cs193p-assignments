//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Sach Vaidya on 8/18/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet : Twitter.Tweet? { didSet { updateUI()} }
    
    private enum TweetMention
    {
        case hashTag
        case url
        case user
    }
    
    private func updateFontColor(of mention: TweetMention, with: UIColor)
    {
        let array : [Mention]?
        switch mention{
        case .hashTag:
            array = tweet?.hashtags
        case .url:
            array = tweet?.urls
        case .user:
            array = tweet?.userMentions
            
        }
        if array != nil{
            let text = tweetTextLabel?.text
            
            if text != nil{
                //let coloredText = NSMutableAttributedString(string: text!)
                let coloredText = tweetTextLabel.attributedText as? NSMutableAttributedString
                
                
                for item in array!
                {
                    coloredText?.addAttribute(NSForegroundColorAttributeName, value: with, range: item.nsrange)
                    tweetTextLabel.attributedText = coloredText
                    
                }
            }
        }
        
    }
    
    
    private func updateUI()
    {
         //UPDATE FONT COLOR OF HASHTAGS,URLS,AND USER MENTIONS
         tweetTextLabel?.text = tweet?.text
         updateFontColor(of: .hashTag, with: UIColor.blue)
         updateFontColor(of: .url, with: UIColor.orange)
         updateFontColor(of: .user, with: UIColor.brown)
        
        
        
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL
        {
            //FIX THIS BLOCKS MAIN QUEUE!
            DispatchQueue.global().async {
                if let imgData = try? Data(contentsOf: profileImageURL)
                {
                    DispatchQueue.main.async{ [weak self] in
                        self?.tweetProfileImageView?.image = UIImage(data: imgData)
                    }
                }
            }
            
        }
        else
        {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created
        {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24 * 60 * 60{
                formatter.dateStyle = .short
            }
            else
            {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        }
        else{
            tweetCreatedLabel?.text = nil
        }
    }
}
