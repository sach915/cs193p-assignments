//
//  GraphView.swift
//  Calculator3
//
//  Created by Sach Vaidya on 8/8/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

protocol GraphDataSource:class{
    func XToY (x:Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    var graphDataSource:GraphDataSource? = nil
    
    @IBInspectable
    var scale:CGFloat = 1 { didSet{setNeedsDisplay()}}
    
    @IBInspectable
    var axes:AxesDrawer = AxesDrawer() { didSet{setNeedsDisplay()}}
    
    @IBInspectable
    var origin = CGPoint() { didSet{setNeedsDisplay()}}
    
    @IBInspectable
    var step:Double = 0.5 { didSet{setNeedsDisplay()}}
    
    private var initialized = false
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state{
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
            //print(scale)
        default:
            break
        }
    }
    
    func changeCenter(byReactingTo tapRecognizer: UITapGestureRecognizer)
    {
        switch tapRecognizer.state{
        case .ended:
           // print("")
           // print("old origin \(origin)")
            let newCenter = tapRecognizer.location(in: self)
           // print("New Center is \(newCenter)")
            
            let dy = bounds.midY - newCenter.y
            origin.y = origin.y + dy
            
            let dx = bounds.midX - newCenter.x
            origin.x = origin.x + dx
           // print("new origin is \(origin)")
            
        default:
            break
        }
    }
    
    func swipeCenter(byReactingTo panRecognizer: UIPanGestureRecognizer)
    {
        switch panRecognizer.state{
        case .changed:
            //print("entered")
            let point = panRecognizer.translation(in: self)
            origin.x = origin.x + point.x
            origin.y = origin.y + point.y
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: self)
        default:
            break
        }
    }
    
    
    private func convertToCGPoint(from : (x:Double,y:Double)) -> CGPoint
    {
        let newX = origin.x + CGFloat(from.x * Double(scale))
        let newY = origin.y + CGFloat((-from.y) * Double(scale))
        //print(newY)
        return CGPoint(x: newX, y: newY)
    }
    
    private func drawGraph()
    {
        
        //print(bounds.maxX)
        //print(bounds.midY)
        //print()
        
        var x = Double(-origin.x)/Double(scale) // leftmost x coord
        var started = false
        let path = UIBezierPath()
        
        
        while(x < Double(bounds.maxX))
        {
            let y = graphDataSource?.XToY(x: x)
            let isRealNumber = !(y?.isNaN ?? false)
            
            if(y != nil)&&(isRealNumber)
            {
                let newPoint = convertToCGPoint(from: (x,y!))
                
                // print(x,y)
                // print(newPoint)
                
                if(!started)
                {
                    path.move(to: newPoint)
                    started = true
                }
                else{
                    path.addLine(to: newPoint)
                }
            }
            x = x + step
        }
        
        
        
        path.stroke()
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if(!initialized)
        {
            origin = CGPoint(x: bounds.midX, y: bounds.midY)
            center = origin
            initialized = true
        }
        //print(origin)
        axes.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        
        drawGraph()
        
        
        
        
    }
    
    
}
