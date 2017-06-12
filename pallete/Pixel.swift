//
//  Pallete.swift
//  pallete
//
//  Created by Toni Jovanoski on 5/16/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

public struct Pixel {
    //public var value: UInt32
    public var value: [Float] = [0.0, 0.0, 0.0, 1.0]
    
    init() {
    }
    
    init(pixel: UInt32) {
        value[0] = Float(UInt8(pixel & 0xFF))
        value[1] = Float(UInt8(pixel >> 8 & 0xFF))
        value[2] = Float(UInt8(pixel >> 16 & 0xFF))
        value[3] = Float(UInt8(pixel >> 24 & 0xFF))
    }
    
    //red
    public var R: Float {
        get { return value[0] }
        set { value[0] = newValue }
    }
    
    //green
    public var G: Float {
        get { return value[1] }
        set { value[1] = newValue }
    }
    
    //blue
    public var B: Float {
        get { return value[2] }
        set { value[2] = newValue }
    }
    
    //alpha
    public var A: Float {
        get { return value[3] }
        set { value[3] = newValue }
    }
}
