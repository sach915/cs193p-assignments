//
//  ViewController.swift
//  FaceIt
//
//  Created by Sach Vaidya on 7/30/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit
//Interprets model for View
class FaceViewController: VCLLoggingViewController {
    
    
    @IBOutlet weak var faceView: FaceView!
        {
        didSet{
            //Adding Gesture Recognizer
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            
            faceView.addGestureRecognizer(pinchRecognizer)
            faceView.addGestureRecognizer(tapRecognizer)
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            updateUI()
        }
        
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .grin)
        {
        didSet{
            updateUI() // executes if expression is changed
        }
    }
    
    func toggleEyes(byReactingTo tapRecognizer : UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended{
            let eyes : FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness()
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    private func updateUI()
    {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin:0.5, .frown:-1.0, .smile:1.0, .smirk:-0.5, .neutral:0.0]
    
}

