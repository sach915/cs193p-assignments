//
//  ImageScrollViewController.swift
//  SmashtagMentions
//
//  Created by Sach Vaidya on 8/21/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {
    
    var image : UIImage?
    {
       /* didSet{
            print("ran didset")
            imageView.image = image
            imageView.sizeToFit()
            print("ran imageView")
            print("end didset")
        }*/
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }

    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet{
            //print("Scroll init")
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.20
            scrollView.maximumZoomScale = 2.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    fileprivate var imageView = UIImageView()
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ImageScrollViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
