//
//  DetailsViewController.swift
//  FoodOrganizer
//
//  Created by Moskaljuk Aleksei on 2/25/19.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit
import CoreML
import Vision

class DetailsViewController: UIViewController {
    
    let imageView = UIImageView()
    var fullImage = UIImage()
    let screen = UIScreen.main.bounds
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        imageView.frame = CGRect(x: 10, y: 80, width: screen.width - 20, height: screen.height / 2)
        imageView.image = fullImage
        view.addSubview(imageView)
    }

}
