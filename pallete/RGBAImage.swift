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
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        let bytesPerRow = width * 4
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
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
        
        imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
        
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func pixel(x: Int, y: Int) -> Pixel? {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return nil
        }
        
        let address = y * width + x
        return pixels[address]
    }
    
    fileprivate func euclidean(p1: Pixel, p2: Pixel) -> Float {
        let rd: Float = Float(p1.R) - Float(p2.R)
        let gd: Float = Float(p1.G) - Float(p2.G)
        let bd: Float = Float(p1.B) - Float(p2.B)
        
        let s: Float = rd + gd + bd
        
        return sqrtf(s)
    }
    
    fileprivate func calculateCentre(points: [Pixel]) -> Pixel {
        let ra: Float = 0.0
        let ba: Float = 0.0
        let ga: Float = 0.0
        
        let sumra: Float = points.reduce(ra) { $0 + Float($1.R) }
        let sumga: Float = points.reduce(ga) { $0 + Float($1.G) }
        let sumba: Float = points.reduce(ba) { $0 + Float($1.B) }
        
        var pixel: Pixel = Pixel(value: 0)
        
        pixel.R = UInt8(sumra / Float(points.count))
        pixel.G = UInt8(sumga / Float(points.count))
        pixel.B = UInt8(sumba / Float(points.count))
        
        return pixel
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
