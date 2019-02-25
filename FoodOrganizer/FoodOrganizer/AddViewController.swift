//
//  AddViewController.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit
import CoreML

protocol ItemAddedDelegate: class {
    func addItem(food: Food)
}

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let screen = UIScreen.main.bounds
    let name = String()
    let amount = Double()
    let date = Date()
    weak var delegate: ItemAddedDelegate?
    
    //    Inputs
    var nameField = UITextField()
    var amountField = UITextField()
    var dateField = UITextField()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        let startingY = (navigationController?.navigationBar.frame.height)! + 20
        
        //        nameField = UITextField(frame: CGRect(x: x, y: 30, width: width, height: height))
        //        amountField = UITextField(frame: CGRect(x: x, y: 90, width: width, height: height))
        //dateField = UITextField(frame: CGRect(x: x, y: 150, width: width, height: height))
        
        imageView.frame = CGRect(x: 15, y: startingY + 30, width: screen.width - 30, height: 300)
        imageView.backgroundColor = .blue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchCamera(_:))))
        view.addSubview(imageView)
        
        let createButton = UIButton(frame: CGRect(x: screen.width / 3, y: screen.maxY - 50, width: screen.width / 4, height: 40))
        createButton.center.x = view.center.x
        createButton.addTarget(self, action: #selector(createNewItem(_:)), for: .touchUpInside)
        createButton.backgroundColor = .blue
        createButton.layer.cornerRadius = 5
        createButton.setTitle("Create", for: .normal)
        view.addSubview(createButton)
    }
    
    @objc func launchCamera(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let photo = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageView.image = photo
        
    }
    
    @objc func createNewItem(_ sender: UIButton) {
        let food = Food(name: "test", amount: 2.5, date: Date(), image: UIImage(named: "apple")!)
        delegate?.addItem(food: food)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

