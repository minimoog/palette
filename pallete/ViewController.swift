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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        image.image = UIImage(named: "tuican.jpg")
        
        var rgbaImage = RGBAImage(image: image.image!)
        rgbaImage?.calculateKMeans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

