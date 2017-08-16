//
//  ViewController.swift
//  Calculator
//
//  Created by Sach Vaidya on 6/15/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController,UISplitViewControllerDelegate {
    
    @IBOutlet weak var display: UILabel! // IMPLICITLY UNWRAPPED OPTIONAL
    //of type optional uilabel because ios needs a quick second to set the optional and connect ui to code. Whenenver it needs to be used you need to unwrap it with ! again
    
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var decimalPressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display!.text!
        
        if userIsInTheMiddleOfTyping
        {
            //Handling decimal values in display
            if decimalPressed
            {
                if digit != "."
                {
                    display!.text = textCurrentlyInDisplay + digit
                }
            }
            else if digit == "."
            {
                display!.text = textCurrentlyInDisplay + digit
                decimalPressed = true
            }
            else
            {
                display!.text = textCurrentlyInDisplay + digit
            }
        }
        else{
            if digit == "."
            {
                display!.text = "0."
                decimalPressed = true
            }
            else{
                display!.text = digit
            }
            userIsInTheMiddleOfTyping = true;
        }
        
    }
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
            // newValue is default for RHS when using assignment operator
        }
    }
    
    //Initialize a private member variable of type calcbrain
    private var brain = CalculatorBrain()
    var dictValues : Dictionary<String,Double>? = nil
    var variableSaved: Bool = false
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        decimalPressed = false
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            
            let evaluation:(Double?,Bool,String)
            
            if(dictValues != nil)
            {
                evaluation = brain.evaluate(using: dictValues)
            }
            else
            {
                evaluation = brain.evaluate()
            }
            
            if(evaluation.0 != nil)
            {
                displayValue = evaluation.0!
            }
            
            
            descriptionDisplay!.text = evaluation.2
            
        }
    }
    
    @IBAction func saveVariable(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        dictValues = nil
        variableSaved = true
    }
    
    
    
    @IBAction func evaluateVariable(_ sender: UIButton) {

        if(variableSaved)
        {
            dictValues = ["M":displayValue]
            let (result,_,description) = brain.evaluate(using: dictValues)
            
            if result != nil{
                displayValue = result!
                descriptionDisplay!.text = description
            }
            
            userIsInTheMiddleOfTyping = false
            variableSaved = false
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController
        {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        
        if let graphViewController = destinationViewController as? GraphViewController
        {
            graphViewController.brain = brain
            
            graphViewController.title = "Graphing : " + (descriptionDisplay.text ?? " ")
        }
    }
}


