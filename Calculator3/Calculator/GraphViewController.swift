//
//  GraphViewController.swift
//  Calculator3
//
//  Created by Sach Vaidya on 8/8/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController,GraphDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var graphView: GraphView!
    {
        didSet{
            graphView.graphDataSource = self
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.changeScale(byReactingTo:)))
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.changeCenter(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 2
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.swipeCenter(byReactingTo:)))
            
            graphView.addGestureRecognizer(pinchRecognizer)
            graphView.addGestureRecognizer(tapRecognizer)
            graphView.addGestureRecognizer(panRecognizer)
        }
    }
    
    var brain = CalculatorBrain()
    


    
    func XToY(x: Double) -> Double? {
       let evaluate = brain.evaluate(using: ["M":x])
        
        return evaluate.0
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
