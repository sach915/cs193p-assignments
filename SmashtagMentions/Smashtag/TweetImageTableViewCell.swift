//
//  TweetImageTableViewCell.swift
//  SmashtagMentions
//
//  Created by Sach Vaidya on 8/20/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    var imageURL : URL? {
        didSet{
            updateUI()
           // setNeedsLayout()
        }
    }
    
    var tweetImage : UIImage?
    {
        return tweetImageView.image
    }
    
    var aspectRatio: Double = 0
    
    private func updateUI()
    {
        if let url = imageURL
        {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imgData = urlContents
                {
                    print("got image")
                    DispatchQueue.main.async {
                        self?.tweetImageView?.contentMode = .scaleAspectFit
                        self?.tweetImageView?.image = UIImage(data: imgData)
                       // print(self?.tweetImageView?.image)
                       // self?.setNeedsLayout()
                       // print("Set image")
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
