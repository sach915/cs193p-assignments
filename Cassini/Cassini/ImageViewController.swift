//
//  ImageViewController.swift
//  Cassini
//
//  Created by Sach Vaidya on 8/13/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    
    //MODEL
    var imageURL : URL?{
        didSet{
            image = nil
            if view.window != nil{ //view.window == nil means its not on screen
                fetchImage()
            }
            
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage()
    {
        if let url = imageURL
        {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
                //This should be on another queue bc it can take a while
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents
                {
                    //using self.image creates a reference cylce where the image remains
                    //and the View Controller can never leave the heap. Fix with weak self
                    //Also never do UI stuff in a global thread. Should all be in main
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                        
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
        {
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            //scrollView may be nil
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
}

extension ImageViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
