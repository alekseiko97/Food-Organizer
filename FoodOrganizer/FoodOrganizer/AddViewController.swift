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
import Photos
import Firebase

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let screen = UIScreen.main.bounds
    let name = String()
    let amount = Double()
    let date = Date()
    let x: CGFloat = 15
    let db = Firestore.firestore()
    
    var imageFilename: String?
    var imageData: Data?
    
    // Labels
    let nameLabel = UILabel()
    let amountLabel = UILabel()
    let expireLabel = UILabel()
    
    // Inputs
    let nameField = UITextField()
    let amountSlider = UISlider()
    let expireSlider = UISlider()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(launchCamera(_:))), animated: true)
        
        let startingY = (navigationController?.navigationBar.frame.height)! + 20
        imageView.frame = CGRect(x: x, y: startingY + 30, width: screen.width - 30, height: 300)
        imageView.image = #imageLiteral(resourceName: "cloud_backup")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery(_:))))
        view.addSubview(imageView)
        
        // Name
        nameLabel.frame = CGRect(x: x, y: startingY + 360, width: 130, height: 20)
        nameLabel.text = "Product name: "
        view.addSubview(nameLabel)
        
        nameField.frame = CGRect(x: 140, y: startingY + 355, width: screen.width - 150, height: 30)
        nameField.placeholder = "Enter product name"
        nameField.delegate = self
        nameField.borderStyle = .roundedRect
        view.addSubview(nameField)
        
        // Amount
        amountLabel.frame = CGRect(x: x, y: startingY + 400, width: 150, height: 20)
        view.addSubview(amountLabel)
        
        amountSlider.frame = CGRect(x: 190, y: startingY + 395, width: 150, height: 20)
        amountSlider.tag = 0
        amountSlider.minimumValue = 1
        amountSlider.maximumValue = 20
        amountSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        amountLabel.text = "Enter amount:  " + String(Int(amountSlider.value))
        view.addSubview(amountSlider)
        
        // Expire
        expireLabel.frame = CGRect(x: x, y: startingY + 445, width: 150, height: 20)
        view.addSubview(expireLabel)
        
        expireSlider.frame = CGRect(x: 190, y: startingY + 440, width: 150, height: 20)
        expireSlider.tag = 1
        expireSlider.minimumValue = 1
        expireSlider.maximumValue = 90
        expireSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        expireLabel.text = "Expire in \(Int(expireSlider.value)) days"
        view.addSubview(expireSlider)
        
        // Create button
        let createButton = UIButton(frame: CGRect(x: screen.width / 3, y: screen.maxY - 50, width: screen.width / 4, height: 40))
        createButton.center.x = view.center.x
        createButton.addTarget(self, action: #selector(createNewItem(_:)), for: .touchUpInside)
        createButton.backgroundColor = .blue
        createButton.layer.cornerRadius = 5
        createButton.setTitle("Create", for: .normal)
        view.addSubview(createButton)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            amountLabel.text = "Enter amount:  " + String(Int(sender.value))
        default:
            expireLabel.text = "Expire in \(Int(sender.value)) days"
        }
        
    }
    
    @objc func launchCamera(_ sender: UITapGestureRecognizer) {
        checkPermission()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func openGallery(_ sender: UIBarButtonItem) {
        checkPermission()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        guard let photo = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageData = photo.sd_imageData()
        
        if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
            imageFilename = PHAssetResource.assetResources(for: asset).first!.originalFilename
        }
        
        imageView.image = photo
        processImage(photo)
    }
    
    func processImage(_ image: UIImage) {
        let model = FoodClassifier()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        switch result.classLabel {
        case "Meat":
            expireSlider.value = 2
            expireLabel.text = "Expire in \(Int(expireSlider.value)) days"
        case "Milk":
             expireSlider.value = 7
            expireLabel.text = "Expire in \(Int(expireSlider.value)) days"
        case "Apple":
            expireSlider.value = 30
            expireLabel.text = "Expire in \(Int(expireSlider.value)) days"
        default:
            expireSlider.value = 1
            expireLabel.text = "Expire in \(Int(expireSlider.value)) days"
        }
        
        //let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        //let converted = String(format: "%.2f", confidence)
        
        //nameField.text = "\(result.classLabel) - \(converted) %"
        nameField.text = "\(result.classLabel)"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func calculateExpiryDate() -> Date {
        // Calculate expiry date (current date + expiry days)
        let expiryDate = Calendar.current.date(byAdding: Calendar.Component.day, value: Int(expireSlider.value), to: Date())
        return expiryDate!
    }
    
    @objc func createNewItem(_ sender: UIButton) {
        
        guard let imageData = imageData else {
            showAlert(message: "Please choose an image")
            return
        }
        
        guard let imageFilename = imageFilename else {
            showAlert(message: "Image filename is not defined")
            return
        }
        
        guard let name = nameField.text, !name.isEmpty else {
            showAlert(message: "Please give a proper name to the food")
            return
        }
        
        Storage.storage().reference().child(imageFilename).putData(imageData, metadata: nil) { (nil, error) in
            if let error = error {
                print(error)
            } else {
                print("Image successfully written")
            }
        }
        
        db.collection("food").document().setData([
            "name": name,
            "amount": Int(amountSlider.value),
            "expiresIn": Int(expireSlider.value),
            "expiryDate": Timestamp(date: calculateExpiryDate()),
            "image": imageFilename,
        ]) { (error) in
            if let error = error {
                print(error)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
