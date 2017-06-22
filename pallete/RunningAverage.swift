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
    var average: Pixel = Pixel()
    var denominator: Int = 1
    
//    init() {
//    }
    
    mutating func push(pixel: Pixel) {
        let diffR = pixel.R - average.R
        let diffG = pixel.G - average.G
        let diffB = pixel.B - average.B
        
        average.R = average.R + diffR / Float(denominator)
        average.G = average.G + diffG / Float(denominator)
        average.B = average.B + diffB / Float(denominator)
        
        denominator += 1
    }
}
