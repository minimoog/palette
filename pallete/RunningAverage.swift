//
//  RunningAverage.swift
//  pallete
//
//  Created by Toni Jovanoski on 6/22/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import Foundation

struct RunningAverage {
    var average: Float = 0.0
    var denominator: Int = 1;
    
    mutating func push(number: Float) {
        let diff = number - average
        
        average = average + diff / Float(denominator)
        denominator += 1
    }
}

struct RunningAveragePixel {
    public var averageR: Float = 0.0
    public var averageG: Float = 0.0
    public var averageB: Float = 0.0
    public var denominator: Int = 1
    
    mutating func push(pixel: Pixel) {
        let diffR = Float(pixel.R) - averageR
        let diffG = Float(pixel.G) - averageG
        let diffB = Float(pixel.B) - averageB
        
        averageR = averageR + diffR / Float(denominator)
        averageG = averageG + diffG / Float(denominator)
        averageB = averageB + diffB / Float(denominator)
        
        denominator += 1
    }
    
    var average: Pixel {
        get {
            var pixel = Pixel()
            pixel.R = UInt8(averageR)
            pixel.G = UInt8(averageG)
            pixel.B = UInt8(averageB)
            
            return pixel
        }
    }
}
