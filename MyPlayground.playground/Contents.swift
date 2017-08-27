//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var str2 = "cos(M)"

var a : ((Double)->Double) = {$0 + 1.0}

var b : ((Double)->Double) = {$0}

var c = {a($0) + b($0)}

print(a(1))
print(b(1))
print(c(1))

enum ab
{
    case b(Double)
    case c(Int)
}

let d = ab.b(4.5)

switch d
{
case .b(let value):
    print(value)
default:
    print("nothing")
}
