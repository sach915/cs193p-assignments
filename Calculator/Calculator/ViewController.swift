//
//  ViewController.swift
//  Calculator
//
//  Created by Sach Vaidya on 6/15/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! // IMPLICITLY UNWRAPPED OPTIONAL
    //of type optional uilabel because ios needs a quick second to set the optional and connect ui to code. Whenenver it needs to be used you need to unwrap it with ! again
    
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var decimalPressed = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //print("\(digit) was called")
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
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        decimalPressed = false
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            
            if let result = brain.result{
                displayValue = result
            }
            
            
            descriptionDisplay!.text = brain.description
            
        }
        
        
    }
    
    
}


