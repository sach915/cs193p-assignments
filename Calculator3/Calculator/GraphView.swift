//
//  GraphView.swift
//  Calculator3
//
//  Created by Sach Vaidya on 8/8/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var scale:CGFloat = 1
    
    var axes:AxesDrawer = AxesDrawer() { didSet{setNeedsDisplay()}}
    
    var function : ((Double) -> Double)? = {pow($0,3)}
    
    var origin = CGPoint()

    
    private func convertToCGPoint(from : (x:Double,y:Double)) -> CGPoint
    {
        let newX = bounds.midX + CGFloat(from.x * Double(scale))
        let newY = bounds.midY + CGFloat((-from.y) * Double(scale))
        //print(newY)
        return CGPoint(x: newX, y: newY)
    }
    
    private func drawGraph()
    {
        print(bounds.maxX)
        print(bounds.midY)
        print()
        
        var x = Double(-bounds.midX)/Double(scale) // leftmost x coord
        var started = false
        let path = UIBezierPath()

        
        while(x < Double(bounds.maxX))
        {
            let y = function!(x)
            let newPoint = convertToCGPoint(from: (x,y))
            print(x,y)
            print(newPoint)
            
            if(!started)
            {
                path.move(to: newPoint)
                started = true
            }
            else{
                path.addLine(to: newPoint)
            }
            x = x + 1
        }
        
        
        
        path.stroke()
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        origin = CGPoint(x: bounds.midX, y: bounds.midY)
        print(origin)
        axes.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        
        if function != nil{
            drawGraph()
        }
        
    
        
    }
    

}
