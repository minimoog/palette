//
//  ViewController.swift
//  pallete
//
//  Created by Toni Jovanoski on 5/16/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        image.image = UIImage(named: "tuican.jpg")
        
        var rgbaImage = RGBAImage(image: image.image!)
        let clusters: [Pixel] = rgbaImage!.calculateKMeans()
       
        for cluster in clusters {
            print(cluster)
        }
        
        color1.backgroundColor = UIColor(red: CGFloat(clusters[0].R / 255.0),
                                         green: CGFloat(clusters[0].G / 255.0),
                                         blue: CGFloat(clusters[0].B / 255.0),
                                         alpha: 1.0)
        
        color2.backgroundColor = UIColor(red: CGFloat(clusters[1].R / 255.0),
                                         green: CGFloat(clusters[1].G / 255.0),
                                         blue: CGFloat(clusters[1].B / 255.0),
                                         alpha: 1.0)
        
        color3.backgroundColor = UIColor(red: CGFloat(clusters[2].R / 255.0),
                                         green: CGFloat(clusters[2].G / 255.0),
                                         blue: CGFloat(clusters[2].B / 255.0),
                                         alpha: 1.0)
        
        color4.backgroundColor = UIColor(red: CGFloat(clusters[3].R / 255.0),
                                         green: CGFloat(clusters[3].G / 255.0),
                                         blue: CGFloat(clusters[3].B / 255.0),
                                         alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

