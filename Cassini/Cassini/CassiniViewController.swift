//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Sach Vaidya on 8/14/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self
        {
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.imageURL == nil
            {
                return true
            }
        }
        return false
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let url = DemoURL.NASA[segue.identifier ?? ""]
        {
            if let imageVC = segue.destination.contents as? ImageViewController
            {
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
            
        }
    }
    

}

extension UIViewController
{
    var contents : UIViewController
    {
        if let navcon = self as? UINavigationController
        {
            return navcon.visibleViewController ?? self
        }
        
        return self
    }
}
