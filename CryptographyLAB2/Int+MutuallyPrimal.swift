//
//  Int+MutuallyPrimal.swift
//  CryptographyLAB2
//
//  Created by Vladislav Kondrashkov on 10/18/18.
//  Copyright © 2018 Vladislav Kondrashkov. All rights reserved.
//

import Foundation

extension Int {
    // Euclidian equation for Greatest Common Divisor
    static func gcd(_ firstNumber: Int, with secondNumber: Int) -> Int {
        var buffer: Int = 0
        var x = firstNumber
        var y = secondNumber
        while y != 0 {
            buffer = y
            y = x % y
            x = buffer
        }
        return x
    }
    
    static func isMutuallyPrimal(_ firstNumber: Int, and secondNumber: Int) -> Bool {
        return Int.gcd(firstNumber, with: secondNumber) == 1
    }
}
