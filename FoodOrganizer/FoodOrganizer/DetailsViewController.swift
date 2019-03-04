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
    
    var fullImage = UIImage()
    let imageView = UIImageView()
    let textView = UITextView()
    let label = UILabel()
    let screen = UIScreen.main.bounds
    let x: CGFloat = 10
    let stackView = UIStackView()
    let images = [#imageLiteral(resourceName: "apple"),#imageLiteral(resourceName: "banana"),#imageLiteral(resourceName: "cheddar")]
    let captions = ["Apple", "Banana", "Cheddar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.setRightBarButton(editButton, animated: true)
        
        imageView.frame = CGRect(x: x, y: 80, width: screen.width - 20, height: screen.height / 2)
        imageView.image = fullImage
        view.addSubview(imageView)
        
        textView.frame = CGRect(x: x, y: (screen.height / 2) + 90, width: screen.width - 20, height: 100)
        textView.backgroundColor = .blue
        view.addSubview(textView)
        
        label.frame = CGRect(x: x, y: (screen.height / 2) + 210, width: screen.width - 20, height: 20)
        label.font = UIFont(name: "Helvetica-Bold", size: 22)
        label.text = "Best matches with"
        label.textAlignment = .center
        view.addSubview(label)
        
        stackView.frame = CGRect(x: x, y: (screen.height / 2) + 250, width: screen.width - 20, height: 100)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
//        stackView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        for img in images {
            let image = UIImageView(image: img)
            image.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            //image.layer.masksToBounds = false
            image.layer.cornerRadius = 50
            image.clipsToBounds = true
            stackView.addArrangedSubview(image)
        }
        
    }
    
    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Edit current product details
    }

}
