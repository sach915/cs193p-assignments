//
//  FaceView.swift
//  FaceIt
//
//  Created by Sach Vaidya on 7/30/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit
@IBDesignable
class FaceView: UIView {
    
    //Public API
    
    @IBInspectable
    var scale : CGFloat = 0.9 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen : Bool = true { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = -0.5 { didSet{ setNeedsDisplay() } } //1.0 = full smile, -1.0 = full frown
    @IBInspectable
    var lineWidth : CGFloat = 5.0 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var color : UIColor = UIColor.blue { didSet{ setNeedsDisplay() } }
    
    func changeScale(byReactingTo pinchRecognizer:UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state{
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    
    //Private Implementations
    
    private var skullRadius : CGFloat{
        return  min(bounds.size.width, bounds.size.height)/2.0 * scale
    }
    //center gives coordinates of center in terms of superview, wrong coordinate system for this view
    //use convert function
    //let skullCenter = convert(center, from: superview) or
    
    private var skullCenter: CGPoint
    {
        return  CGPoint(x: bounds.midX,y: bounds.midY)
    }
    
    private enum Eye{
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath
    {
        func centerOfEye(_ eye: Eye)-> CGPoint
        {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y = eyeCenter.y - eyeOffset
            eyeCenter.x = eyeCenter.x + ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        let path: UIBezierPath
        
        if eyesOpen{
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        }
        else{
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius , y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        
        path.lineWidth = lineWidth
        
        return path
        
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius/Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius/Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        let cp1 = CGPoint(x: start.x + mouthRect.width/3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width/3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    private func pathForSkull() -> UIBezierPath
    {
        //Angles are in radians
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        path.lineWidth = lineWidth //set width
        
        return path
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("called")
        //scale = (min(scale,0.9))
        color .set()   //set color
        pathForSkull().stroke()       // draw
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        
        
    }
    
    //How to declare constants in swift
    private struct Ratios{
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
        
        
        
        
    }
    
    
}
