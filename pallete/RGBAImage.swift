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
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
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
        
        pixels = Array(UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height))
    }
    
    func calculateKMeans() {
        kMeans(points: pixels, K: 4, minDiff: 0.001)
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
    
    fileprivate func kMeans(points: [Pixel], K: Int, minDiff: Float) {
        
        var clusters: [Pixel] = [Pixel]()
        
        while clusters.count < K {
            let idx = arc4random_uniform(UInt32(points.count))
            clusters.append(points[Int(idx)])
        }
    
        var plists: [[Int]]
        
        for _ in 0..<K {
            plists.append([])
        }
        
        while true {
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
                
                plists[index].append(i)
            }
            
            var diff: Float = 0
            
            for i in 0..<K {
                let old = clusters[i]
                let list = plists[i]
                
                let pointlist = list.map{ points[$0] }
                
                let centre = calculateCentre(points: pointlist)
                let newCluster = centre
                
                let dist = euclidean(p1: old, p2: centre)
                
                clusters[i] = newCluster
                
                diff = diff > dist ? diff : dist
            }
            
            if (diff < minDiff) {
                break;
            }
        }
    }
}
