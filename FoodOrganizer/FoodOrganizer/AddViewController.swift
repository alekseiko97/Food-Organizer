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
   // var dateField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let width: CGFloat = screen.width - 20
        let height: CGFloat = 50
        let x: CGFloat = 10

        nameField = UITextField(frame: CGRect(x: x, y: 30, width: width, height: height))
        amountField = UITextField(frame: CGRect(x: x, y: 90, width: width, height: height))
        //dateField = UITextField(frame: CGRect(x: x, y: 150, width: width, height: height))
        let confirmButton = UIButton(frame: CGRect(x: screen.width / 2, y: screen.height - 100, width: width / 2, height: height))
        confirmButton.addTarget(self, action: #selector(createNewItem(_:)), for: .touchUpInside)
        confirmButton.backgroundColor = .blue
        
        view.addSubview(nameField)
        view.addSubview(amountField)
        //view.addSubview(dateField)
        view.addSubview(confirmButton)
    }
    
    @objc func createNewItem(_ sender:UIButton) {
        print("pressed")
        let food = Food(name: "Name", amount: 2.5, date: Date(), image: UIImage(named: "apple")!)
        delegate?.addItem(food: food)
        navigationController?.popViewController(animated: true)
    }
    
}
