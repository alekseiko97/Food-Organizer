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

class ViewController: UIViewController, ItemAddedDelegate, UISearchBarDelegate {
    
    // Global variables
    let screen = UIScreen.main.bounds
    let cellHeight: CGFloat = 150
    var startY: CGFloat = 0
    var x: CGFloat = 15
    var foodArray = [Food]()
    var counter: CGFloat = 0
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Food Organizer"
        navigationController?.navigationBar.backgroundColor = .green
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.action = #selector(addButtonPressed)
        navigationItem.setRightBarButton(addButton, animated: true)
        
        //  Dummy data
        let apple = Food(name: "Apple", amount: 2, date: Date(), image: #imageLiteral(resourceName: "apple"))
        let cheddar = Food(name: "Cheddar", amount: 1, date: Date(), image: #imageLiteral(resourceName: "cheddar"))
        foodArray.append(contentsOf: [apple, cheddar])
        
        self.startY = (navigationController?.navigationBar.frame.height)! + 20
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: startY, width: screen.width, height: 50))
        view.addSubview(searchBar)
        
        scrollView.frame = CGRect(x: 0, y: startY + 50, width: screen.width, height: screen.height)
        scrollView.contentSize = CGSize(width: screen.width, height: CGFloat(foodArray.count) * cellHeight)
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        let header = UILabel(frame: CGRect(x: x, y: 20, width: screen.width, height: 30))
        header.text = "Expiring soon"
        header.font = UIFont(name: "Helvetica-Bold", size: 25)
        scrollView.addSubview(header)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        
        for food in foodArray {
            let frame = CGRect(x: x, y: 60 + (cellHeight + 20) * counter, width: screen.width - x * 2, height: cellHeight)
            let myView = MyView(frame: frame, food: food)
            myView.tag = Int(counter)
            //myView.addGestureRecognizer(longPressGesture)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            myView.addGestureRecognizer(tapGesture)
            counter += 1
            scrollView.addSubview(myView)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Implement filter
        for food in foodArray {
            if food.name.contains(searchText) {
                
            }
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        // TODO: Go to the next page with more details
        let detailsVC = DetailsViewController()
        detailsVC.fullImage = foodArray[sender.view!.tag].image
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc func longPressed(_ sender: UIButton) {
        // TODO: Long press pops up a context menu with options (delete, move) (something like 3D Touch)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        let nextVC = AddViewController()
        nextVC.delegate = self as ItemAddedDelegate
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.setScrollViewContentSize()
    }
    
    func addItem(food: Food) {
        foodArray.append(food)
        let frame = CGRect(x: x, y: 60 + (cellHeight + 20) * CGFloat(foodArray.count - 1), width: screen.width - x * 2, height: cellHeight)
        let newView = MyView(frame: frame, food: food)
        newView.tag = foodArray.count - 1
        scrollView.addSubview(newView)
    }

}

extension UIScrollView {
    func updateContentView() {
        
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
    
    func setScrollViewContentSize() {
        
        var height: CGFloat
        let lastView = self.subviews.last!
       // print(lastView.debugDescription) // should be what you expect
        
        let lastViewYPos = lastView.convert(lastView.frame.origin, to: nil).y  // this is absolute positioning, not relative
        let lastViewHeight = lastView.frame.size.height
        
        // sanity check on these
        //print(lastViewYPos)
        //print(lastViewHeight)
        
        height = lastViewYPos
        
        //print("setting scroll height: \(height)")
        
        contentSize.height = height
    }
}

