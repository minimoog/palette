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
        
        pixels = UnsafeMutableBufferPointer(start: imageData, count: width * height)
        
        defer {
            imageData.deallocate(capacity: width * height)
        }
    }
    
    func calculateKMeans() -> [Pixel] {
        return kMeans(points: pixels, K: 4, minDiff: 5.0)
    }
    
    public func pixel(x: Int, y: Int) -> Pixel? {
        guard x >= 0 && x < width && y >= 0 && y < height else {
            return nil
        }
        
        let address = y * width + x
        return pixels[address]
    }
    
    fileprivate func euclidean(p1: Pixel, p2: Pixel) -> Float {
        let rd = Float(p1.R) - Float(p2.R)
        let gd = Float(p1.G) - Float(p2.G)
        let bd = Float(p1.B) - Float(p2.B)
        
        let s: Float = rd * rd + gd * gd  + bd * bd
        
        //return sqrtf(s)
        return s
    }
    
    fileprivate func calculateCentre(points: [Pixel]) -> Pixel {
        var sumr: Float = 0.0
        var sumg: Float = 0.0
        var sumb: Float = 0.0
        
        for pixel in points {
            sumr += Float(pixel.R) // ### opt
            sumg += Float(pixel.G)
            sumb += Float(pixel.B)
        }
        
        var pixel: Pixel = Pixel()
        
        pixel.R = UInt8(sumr / Float(points.count))
        pixel.G = UInt8(sumg / Float(points.count))
        pixel.B = UInt8(sumb / Float(points.count))
        
        return pixel
    }
    
    fileprivate func kMeans(points: UnsafeMutableBufferPointer<Pixel>, K: Int, minDiff: Float) -> [Pixel] {
        
        var clusters: [Pixel] = [Pixel]()
        
        while clusters.count < K {
            let idx = arc4random_uniform(UInt32(points.count))
            clusters.append(points[Int(idx)])
        }
    
        
        while true {
            var averages = [RunningAveragePixel](repeating: RunningAveragePixel(), count: K)
            
            for _ in (0..<points.count / 100) {
                var smallestDistance: Float = 10000000.0
                var index = 0
                
                let randomIndex = arc4random_uniform(UInt32(points.count))                
                let pixel = points[Int(randomIndex)]
                
                for j in 0..<K {
                    let distance = euclidean(p1: pixel, p2: clusters[j])
                    
                    if distance < smallestDistance {
                        smallestDistance = distance
                        index = j
                    }
                }
                
                averages[index].push(pixel: pixel)
            }
            
            var diff: Float = 0
            
            for i in 0..<K {
                let old = clusters[i]
                
                let centre = averages[i].average
                let newCluster = centre
                
                let dist = euclidean(p1: old, p2: centre)
                
                clusters[i] = newCluster
                
                diff = diff > dist ? diff : dist
            }
            
            print("Diff \(diff)/n")
            
            if diff < minDiff {
                break
            }
        }
        
        return clusters
    }
}
