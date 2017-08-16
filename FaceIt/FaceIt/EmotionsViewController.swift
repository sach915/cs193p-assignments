//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Sach Vaidya on 8/8/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destinationViewController = segue.destination
        
        if let navigationViewController = destinationViewController as? UINavigationController
        {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        
        if let faceViewController = destinationViewController as? FaceViewController
        {
            if let identifier = segue.identifier
            {
                if let expression = emotialFaces[identifier]
                {
                    faceViewController.expression = expression
                }
                
            }
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle 
        }
    }
    
    private let emotialFaces : Dictionary <String,FacialExpression> = [
        "sad":FacialExpression(eyes:.closed, mouth:.frown),
        "happy":FacialExpression(eyes:.open, mouth:.smile),
        "worried":FacialExpression(eyes:.open, mouth:.smirk)
    ]
    

}
