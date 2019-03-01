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
    let textView = UITextView()
    var fullImage = UIImage()
    let screen = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.setRightBarButton(editButton, animated: true)
        
        imageView.frame = CGRect(x: 10, y: 80, width: screen.width - 20, height: screen.height / 2)
        imageView.image = fullImage
        view.addSubview(imageView)
        
        textView.frame = CGRect(x: 10, y: (screen.height / 2) + 90, width: screen.width - 20, height: 200)
        textView.backgroundColor = .blue
        view.addSubview(textView)
    }
    
    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Edit current product details
    }

}
