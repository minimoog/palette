//
//  ViewController.swift
//  pallete
//
//  Created by Toni Jovanoski on 5/16/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        image.image = UIImage(named: "tuican.jpg")
        
        calcKMeans(image.image!)
    }
    
    private func calcKMeans(_ image: UIImage) {
        let rgbaImage = RGBAImage(image: image)
        let clusters: [Pixel] = rgbaImage!.calculateKMeans()
        
        showClusterColors(clusters)
    }
    
    private func showClusterColors(_ clusters: [Pixel]) {
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
    
    @IBAction func onImageViewTouch(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        image.image = pickedImage
        calcKMeans(pickedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

