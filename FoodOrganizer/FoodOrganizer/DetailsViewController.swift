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

class BestMatchView: UIView {
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        img.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.width / 2
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: 85, width: 70, height: 20)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(frame: CGRect, image: UIImage, caption: String) {
        self.init(frame: frame)
        
        self.image.image = image
        self.label.text = caption
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(image)
        addSubview(label)
    }
}

class DetailsViewController: UIViewController {
    
    var fullImage = UIImage()
    let imageView = UIImageView()
    let textView = UITextView()
    let label = UILabel()
    let screen = UIScreen.main.bounds
    let x: CGFloat = 10
    let stackView = UIStackView()
    var desc: String!
    var combiners: [[UIImage: String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.setRightBarButton(editButton, animated: true)
        
        imageView.frame = CGRect(x: x, y: 80, width: screen.width - 20, height: screen.width - 80)
        imageView.image = fullImage
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        textView.frame = CGRect(x: x, y: screen.width + 10, width: screen.width - 20, height: 130)
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = desc
        textView.isEditable = false
        view.addSubview(textView)
        
        label.frame = CGRect(x: x, y: (screen.height / 2) + 210, width: screen.width - 20, height: 20)
        label.font = UIFont(name: "Helvetica-Bold", size: 22)
        label.text = "Best combines with"
        label.textAlignment = .center
        view.addSubview(label)
        
        stackView.frame = CGRect(x: x + 10, y: (screen.height / 2) + 210, width: screen.width - 20, height: 100)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20

        view.addSubview(stackView)
        
        for c in combiners {
            for (image, caption) in c {
                let bmw = BestMatchView(frame: CGRect(x: x, y: 0, width: 50, height: 50), image: image, caption: caption)
                stackView.addArrangedSubview(bmw)
            }
        }
    }
    
    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Edit current product details
    }

}
