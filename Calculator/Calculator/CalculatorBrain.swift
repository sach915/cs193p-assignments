//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sach Vaidya on 6/24/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import Foundation




struct CalculatorBrain {
    
    private var accumulator : Double?
    var description = " "
    private var descriptionBeforeOperandAdded = " "
    private var M:Double?
    
    
    //making a new "type" so that our dictionary can have multiple value types. Under scope of CalculatorBrain
    //so its type is CalculatorBrain.constant or CalculatorBrain.unaryOperation
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double) // of type function that takes a double and returns a double
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
        
    }
    
    private var operations : Dictionary <String,Operation> =
        [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "C" : Operation.clear,
            "√" : Operation.unaryOperation(sqrt), //sqrt
            "cos" : Operation.unaryOperation(cos), //cos
            "sin" : Operation.unaryOperation(sin),
            "tan" : Operation.unaryOperation(tan),
            "e^x" : Operation.unaryOperation({$0}),
            "±" : Operation.unaryOperation({-$0}),
            "%" : Operation.unaryOperation({$0 / 100.0}),
            "×" : Operation.binaryOperation({$0 * $1}),
            "÷" : Operation.binaryOperation({$0 / $1}),
            "+" : Operation.binaryOperation({$0 + $1}),
            "-" : Operation.binaryOperation({$0 - $1}),
            "x^y" : Operation.binaryOperation(pow),
            "x^2" : Operation.unaryOperation({$0}),
            "=" : Operation.equals,
            
            
            ]
    
    mutating func performOperation (_ symbol:String)
    {
        if let operation = operations[symbol]
        {
            switch operation{
            case .constant(let value): //associated constant value
                accumulator = value
                if resultIsPending{
                    //if in the middle of a calculation, append to the existing description
                    description = description + "\(symbol)"
                }
                else{
                    //reset description to new symbol
                    description =  "\(symbol)"
                }
            case .unaryOperation(let function):
                if accumulator != nil {
                    
                    //cases for unique unary operators
                    if symbol == "e^x"
                    {
                        description = "e^(\(description))"
                        accumulator = pow(M_E,accumulator!)
                    }
                    else if symbol == "x^2"
                    {
                        description = "(\(description))^2"
                        accumulator = pow(accumulator!,2)
                        
                    }
                    else{
                        if symbol == "%"
                        {
                            description = "\(description) \(symbol)"
                        }
                        else{
                            if resultIsPending
                            {
                                description = descriptionBeforeOperandAdded + "\(symbol)(\(accumulator!))"
                            }
                            else{
                                description = "\(symbol)(\(description))"
                            }
                        }
                        accumulator = function(accumulator!)
                    }
                }
            case .binaryOperation(let function):
                if resultIsPending{
                    performPendingBinaryOperation()
                }
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    if symbol != "x^y" {
                        description = "(\(description)) \(symbol) "
                    }
                    else
                    {
                        description = "(\(description))^"
                    }
                    accumulator = nil
                }
                
                
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                pendingBinaryOperation = nil
                accumulator = 0
                description = " "
                
                
            }
        }
       // print(description)
    }
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: ((Double,Double) -> Double)
        let firstOperand : Double
        
        func perform(with secondOperand : Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    
    var resultIsPending : Bool{
        get{
            return (pendingBinaryOperation != nil)
        }
        set{
            
        }
    }
    
    mutating func setOperand(_ operand:Double)
    {
        accumulator = operand
        descriptionBeforeOperandAdded = description
        
        if resultIsPending
        {
            description = description + String(operand)
        }
        else
        {
            description = String(operand)
        }
        
    }
    
    var result: Double?{
        get {
            return accumulator
        }
    }
    

    
}
