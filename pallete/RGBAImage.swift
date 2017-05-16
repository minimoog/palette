//
//  RGBAImage.swift
//  pallete
//
//  Created by Toni Jovanoski on 5/17/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

public struct RGBAImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let bytesPerRow = width * 4
        let imageData = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: imageData,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: 8,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo) else
        {
            return nil
        }
        
        imageContext.draw(cgImage, CGRect(origin: .zero, size: size))
        
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func pixel(x: Int, y: Int) -> Pixel? {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return nil
        }
        
        let address = y * width + x
        return pixels?[address]
    }
}

/*
extension UIImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let bytesPerRow = width * 4
        let imageData = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: imageData,
                                         width: width,
                                         height: height,
                                         bitsPerComponent: 8,
                                         bytesPerRow: bytesPerRow,
                                         space: colorSpace,
                                         bitmapInfo: bitmapInfo) else
        {
            return nil
        }
        
        imageContext.draw(cgImage, CGRect(origin: .zero, size: size))
        
        return UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func pixel(x: Int, y: Int) -> Pixel? {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return nil
        }
        
        let address = y * width + x
        return pixels?[address]
    }
    
    public var width: Int {
        return Int(self.size.width)
    }
    
    public var height: Int {
        return Int(self.size.height)
    }
}
 */
