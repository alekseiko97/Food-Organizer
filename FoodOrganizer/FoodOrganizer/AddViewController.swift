//
//  AddViewController.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol ItemAddedDelegate: class {
    func addItem(food: Food)
}


class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let screen = UIScreen.main.bounds
    let name = String()
    let amount = Double()
    let date = Date()
    let x: CGFloat = 15
    weak var delegate: ItemAddedDelegate?
    
    // Labels
    let nameLabel = UILabel()
    let amountLabel = UILabel()
    let expireLabel = UILabel()
    
    // Inputs
    let nameField = UITextField()
    let amountStepper = UIStepper()
    let expireDaysStepper = UIStepper()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let startingY = (navigationController?.navigationBar.frame.height)! + 20
        imageView.frame = CGRect(x: x, y: startingY + 30, width: screen.width - 30, height: 300)
        imageView.image = #imageLiteral(resourceName: "cloud_backup")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchCamera(_:))))
        view.addSubview(imageView)
        
        // Name
        nameLabel.frame = CGRect(x: x, y: startingY + 360, width: 130, height: 20)
        nameLabel.text = "Product name: "
        view.addSubview(nameLabel)
        
        nameField.frame = CGRect(x: 140, y: startingY + 361, width: screen.width - 70, height: 20)
        view.addSubview(nameField)
        
        // Amount
        amountLabel.frame = CGRect(x: x, y: startingY + 400, width: 150, height: 20)
        view.addSubview(amountLabel)
        
        amountStepper.frame = CGRect(x: 190, y: startingY + 395, width: screen.width - 70, height: 20)
        amountStepper.tag = 0
        amountStepper.minimumValue = 1
        amountStepper.maximumValue = 20
        amountStepper.wraps = true
        amountStepper.autorepeat = true
        amountStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        amountLabel.text = "Enter amount:  " + String(Int(amountStepper.value))
        view.addSubview(amountStepper)
        
        //Expire
        expireLabel.frame = CGRect(x: x, y: startingY + 445, width: 150, height: 20)
        view.addSubview(expireLabel)
        
        expireDaysStepper.frame = CGRect(x: 190, y: startingY + 440, width: 150, height: 20)
        expireDaysStepper.tag = 1
        expireDaysStepper.minimumValue = 1
        expireDaysStepper.maximumValue = 20
        expireDaysStepper.wraps = true
        expireDaysStepper.autorepeat = true
        expireDaysStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        expireLabel.text = "Expire in \(Int(expireDaysStepper.value)) days"
        view.addSubview(expireDaysStepper)
        
        // Create button
        let createButton = UIButton(frame: CGRect(x: screen.width / 3, y: screen.maxY - 50, width: screen.width / 4, height: 40))
        createButton.center.x = view.center.x
        createButton.addTarget(self, action: #selector(createNewItem(_:)), for: .touchUpInside)
        createButton.backgroundColor = .blue
        createButton.layer.cornerRadius = 5
        createButton.setTitle("Create", for: .normal)
        view.addSubview(createButton)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        switch sender.tag {
        case 0:
            amountLabel.text = "Enter amount:  " + String(Int(sender.value))
        default:
             expireLabel.text = "Expire in \(Int(sender.value)) days"
        }
    }

    
    @objc func launchCamera(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary // change to camera later
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
        processImage(photo)
    }
    
    func processImage(_ image: UIImage) {
        let model = Inceptionv3()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }

        //let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        //let converted = String(format: "%.2f", confidence)
        
        //nameField.text = "\(result.classLabel) - \(converted) %"
        nameField.text = "\(result.classLabel)"
    }
    
    @objc func createNewItem(_ sender: UIButton) {
        let food = Food(name: nameField.text!, amount: Int(amountStepper.value), expiry: Int(expireDaysStepper.value), image: imageView.image!)
        delegate?.addItem(food: food)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


