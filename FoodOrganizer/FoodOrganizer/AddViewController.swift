//
//  AddViewController.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit

protocol ItemAddedDelegate: class {
    func addItem(food: Food)
}



class AddViewController: UIViewController {
    
    let screen = UIScreen.main.bounds
    let name = String()
    let amount = Double()
    let date = Date()
    weak var delegate: ItemAddedDelegate?
    
//    Inputs
    var nameField = UITextField()
    var amountField = UITextField()
    var dateField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        let startingY = (navigationController?.navigationBar.frame.height)! + 20

//        nameField = UITextField(frame: CGRect(x: x, y: 30, width: width, height: height))
//        amountField = UITextField(frame: CGRect(x: x, y: 90, width: width, height: height))
        //dateField = UITextField(frame: CGRect(x: x, y: 150, width: width, height: height))
        
        let image = UIImageView(frame: CGRect(x: 15, y: startingY + 30, width: screen.width - 30, height: 300))
        image.backgroundColor = .blue
        view.addSubview(image)
        
        let createButton = UIButton(frame: CGRect(x: screen.width / 3, y: screen.maxY - 50, width: screen.width / 4, height: 40))
        createButton.center.x = view.center.x
        createButton.addTarget(self, action: #selector(createNewItem(_:)), for: .touchUpInside)
        createButton.backgroundColor = .blue
        createButton.layer.cornerRadius = 5
        createButton.setTitle("Create", for: .normal)
        view.addSubview(createButton)
    }
    
    @objc func createNewItem(_ sender:UIButton) {
        let food = Food(name: "test", amount: 2.5, date: Date(), image: UIImage(named: "apple")!)
        delegate?.addItem(food: food)
        navigationController?.popViewController(animated: true)
    }
    
}
