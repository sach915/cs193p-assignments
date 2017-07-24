//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sach Vaidya on 6/24/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import Foundation




struct CalculatorBrain {
    
    private var accumulator : (Double?,String) = (nil," ")
    //var description = " "
    private var sequenceOfOperations = [String]()
    
    
    //making a new "type" so that our dictionary can have multiple value types. Under scope of CalculatorBrain
    //so its type is CalculatorBrain.constant or CalculatorBrain.unaryOperation
    
    private enum Operation{
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String)->String) // of type function that takes a double and returns a double
        case binaryOperation((Double, Double) -> Double, (String,String)->String)
        case equals
        case clear
        
    }
    
    private var operations : Dictionary <String,Operation> =
        [
            "π" : Operation.constant(Double.pi,"π"),
            "e" : Operation.constant(M_E,"e"),
            "C" : Operation.clear,
            "√" : Operation.unaryOperation(sqrt, {"√("+$0+")"}), //sqrt
            "cos" : Operation.unaryOperation(cos, {"cos("+$0+")"}), //cos
            "sin" : Operation.unaryOperation(sin,{"sin("+$0+")"}),
            "tan" : Operation.unaryOperation(tan,{"tan("+$0+")"}),
            "e^x" : Operation.unaryOperation({pow(M_E,$0)},{"e^("+$0+")"}),
            "±" : Operation.unaryOperation({-$0}, {"±("+$0+")"}),
            "%" : Operation.unaryOperation({$0 / 100.0}, {"("+$0+")"+"%"}),
            "×" : Operation.binaryOperation({$0 * $1}, {"("+$0+"×"+$1+")"}),
            "÷" : Operation.binaryOperation({$0 / $1}, {"("+$0+"÷"+$1+")"}),
            "+" : Operation.binaryOperation({$0 + $1}, {"("+$0+"+"+$1+")"}),
            "-" : Operation.binaryOperation({$0 - $1}, {"("+$0+"-"+$1+")"}),
            "x^y" : Operation.binaryOperation(pow, {$0+"^("+$1+")"}),
            "x^2" : Operation.unaryOperation({$0 * $0}, {"("+$0+")^2"}),
            "=" : Operation.equals
        ]
    
    mutating func performOperation (_ symbol:String)
    {
        sequenceOfOperations.append(symbol)
        
        if let operation = operations[symbol]
        {
            print(accumulator.1)
            
            switch operation{
            case .constant(let value, let character): //associated constant value
                accumulator.0 = value
                accumulator.1 =  character
            case .unaryOperation(let function, let descriptor):
                if accumulator.0 != nil {
                    accumulator.1 = descriptor(accumulator.1)
                    accumulator.0 = function(accumulator.0!)
                }
            case .binaryOperation(let function, let descriptor):
                    performPendingBinaryOperation()
                
                
                if accumulator.0 != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!, descriptionFunction : descriptor, descriptionSoFar: accumulator.1)
                    accumulator.0 = nil
                }
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                pendingBinaryOperation = nil
                accumulator.0 = 0
                description = " "
            }
        }
    }
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator.0 != nil {
            //print( String(accumulator.0!) + " " + accumulator.1)
            accumulator.1 = pendingBinaryOperation!.describe(with: accumulator.1)
            accumulator.0 = pendingBinaryOperation!.perform(with: accumulator.0!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: ((Double,Double) -> Double)
        let firstOperand : Double
        let descriptionFunction: ((String,String) -> String)
        let descriptionSoFar : String
        
        func perform(with secondOperand : Double) -> Double {
            return function(firstOperand,secondOperand)
        }
        
        func describe(with secondOperand: String) -> String {
            
            return descriptionFunction(descriptionSoFar, secondOperand)
        }
        
   
        

    }
    
    var resultIsPending : Bool{
        get{
            return (pendingBinaryOperation != nil)
        }
    }
    
    mutating func setOperand(_ operand:Double)
    {
        accumulator.0 = operand
        sequenceOfOperations.append(String(operand))
        accumulator.1 = String(operand)
        
    }
    
    mutating func setOperand(variable named: String)
    {
        accumulator.0 = 0
        sequenceOfOperations.append("M")
        accumulator.1 = named
    }
    
    func evaluate(using variables: Dictionary<String,Int>? = nil)->(result:Double?, isPending:Bool,description:String)
    {
        for op in sequenceOfOperations
        {
            print("op is")
            print(op)
            
            
        }
        
        return(0,resultIsPending,description)
    }
    
    
    
    var description: String
    {
        get{


                return accumulator.1
           
        }
        set{
            accumulator.1 = newValue
        }
    }
    
    var result: Double?{
        get {
                return accumulator.0
        }
    }
    
}
