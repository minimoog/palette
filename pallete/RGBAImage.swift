//
//  RGBAImage.swift
//  pallete
//
//  Created by Toni Jovanoski on 5/17/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

public struct RGBAImage {
    public var pixels: [Pixel] = []
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        let bytesPerRow = width * 4
        //let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        let imageData = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height)
        
        defer {
            imageData.deallocate(capacity: width * height)
        }
        
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
        
        //pixels = Array(UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height))
        
        let buffer = UnsafeMutableBufferPointer(start: imageData, count: width * height)
        pixels = buffer.map {
            return Pixel(pixel: $0)
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
        let rd = p1.R - p2.R
        let gd = p1.G - p2.G
        let bd = p1.B - p2.B
        
        let s: Float = rd * rd + gd * gd  + bd * bd
        
        //return sqrtf(s)
        return s
    }
    
    fileprivate func calculateCentre(points: [Pixel]) -> Pixel {
        var sumr: Float = 0.0
        var sumg: Float = 0.0
        var sumb: Float = 0.0
        
        for pixel in points {
            sumr += pixel.R
            sumg += pixel.G
            sumb += pixel.B
        }
        
        var pixel: Pixel = Pixel()
        
        pixel.R = sumr / Float(points.count)
        pixel.G = sumg / Float(points.count)
        pixel.B = sumb / Float(points.count)
        
        return pixel
    }
    
    fileprivate func kMeans(points: [Pixel], K: Int, minDiff: Float) -> [Pixel] {
        
        var clusters: [Pixel] = [Pixel]()
        
        while clusters.count < K {
            let idx = arc4random_uniform(UInt32(points.count))
            clusters.append(points[Int(idx)])
        }
    
        
        while true {
            
            var plists: [Int: [Int]] = [0: [], 1: [], 2: [], 3: []]
            
            for (i, pixel) in points.enumerated() {
                var smallestDistance: Float = 10000000.0
                var index = 0
                
                for j in 0..<K {
                    let distance = euclidean(p1: pixel, p2: clusters[j])
                    
                    if distance < smallestDistance {
                        smallestDistance = distance
                        index = j
                    }
                }
                
                plists[index]?.append(i)
            }
            
            var diff: Float = 0
            
            for i in 0..<K {
                let old = clusters[i]
                
                let centre = calculateCentre(points: (plists[i]?.map { return pixels[$0] })!)
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
