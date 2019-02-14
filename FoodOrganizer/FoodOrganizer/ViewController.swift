//
//  ViewController.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit

class Food: NSObject {
    
    var name: String!
    var amount: Double!
    var date: Date!
    var image: UIImage!
    
    init(name: String, amount: Double, date: Date, image: UIImage) {
        self.name = name
        self.amount = amount
        self.date = date
        self.image = image
    }

}

class ViewController: UIViewController, ItemAddedDelegate {
    
    // Variables
    let screen = UIScreen.main.bounds
    var foodArray = [Food]()
    var counter: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Food Organizer"
        navigationController?.navigationBar.backgroundColor = .green
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.action = #selector(addButtonPressed)
        navigationItem.setRightBarButton(addButton, animated: true)
        
        let startingHeight = (navigationController?.navigationBar.frame.height)! + 20
        let x: CGFloat = 15
        
        // TODO: Implement filter
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: startingHeight, width: screen.width, height: 50))
        view.addSubview(searchBar)
        
        let header = UILabel(frame: CGRect(x: x, y: startingHeight + 70, width: screen.width, height: 30))
        header.text = "Expiring soon"
        header.font = UIFont(name: "Helvetica-Bold", size: 25)
        view.addSubview(header)
        
//        let scrollView = UIScrollView(frame: CGRect(x: 40, y: 30, width: screen.width - 60, height: 80))
//        scrollView.backgroundColor = UIColor.blue
//        view.addSubview(scrollView)
        
        //  Dummy data
        let apple = Food(name: "Apple", amount: 2, date: Date(), image: UIImage(named: "apple")!)
        let cheddar = Food(name: "Cheddar", amount: 1, date: Date(), image: UIImage(named: "cheddar")!)
        foodArray.append(contentsOf: [apple, cheddar])

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    
        for food in foodArray {
            let myView = MyView(frame: CGRect(x: x, y: (startingHeight + 110) + 170 * counter, width: screen.width - x * 2, height: 150), image: food.image, name: food.name, amount: food.amount, due: food.date)
            myView.tag = Int(counter)
            myView.addGestureRecognizer(longPressGesture)
            myView.addGestureRecognizer(tapGesture)
            counter += 1
            view.addSubview(myView)
        }
        
        
    }
    
    @objc func tapped(_ sender: UIButton) {
        // TODO -> Go to the next pages with more details
    }
    
    @objc func longPressed(_ sender: UIButton) {
        // TODO -> Long press pops up a context menu with options (delete, move)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        let nextVC = AddViewController()
        nextVC.delegate = self as ItemAddedDelegate
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func addItem(food: Food) {
        let new = MyView(frame: CGRect(x: 15, y: (200 + 110) + 170 * 2, width: screen.width - 15 * 2, height: 150), image: food.image, name: food.name, amount: food.amount, due: food.date)
        view.addSubview(new)
    }


}

