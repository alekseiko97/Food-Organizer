//
//  ViewController.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class Food: NSObject {
    
    var id: String!
    var name: String!
    var desc: String?
    var amount: Int?
    var expiry: Int?
    var imageRef: String?
    var combiners: [[String: String]]?
    
    init(id: String, name: String, description: String, amount: Int, expiry: Int, imageRef: String, combiners: [[String: String]]) {
        super.init()
        self.id = id
        self.name = name
        self.desc = description
        self.amount = amount
        self.expiry = expiry
        self.imageRef = imageRef
        self.combiners = combiners
    }
    
    init(id: String, name: String, amount: Int, expiry: Int, imageRef: String) {
        super.init()
        self.id = id
        self.name = name
        self.amount = amount
        self.expiry = expiry
        self.imageRef = imageRef
    }
}

class ViewController: UIViewController, UISearchBarDelegate {
    
    // Global variables
    let screen = UIScreen.main.bounds
    let cellHeight: CGFloat = 170
    var startY: CGFloat = 0
    var x: CGFloat = 15
    var foodArray = [Food]()
    var myViews = [MyView]()
    var counter: CGFloat = 0
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    // Firestore reference
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Food Organizer"
        navigationController?.navigationBar.backgroundColor = .green
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.action = #selector(addButtonPressed)
        navigationItem.setRightBarButton(addButton, animated: true)
        
        self.startY = (navigationController?.navigationBar.frame.height)! + 20
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: startY, width: screen.width, height: 50))
        view.addSubview(searchBar)

        scrollView.frame = CGRect(x: 0, y: startY + 50, width: screen.width, height: screen.height)
        scrollView.isScrollEnabled = true
        
        view.addSubview(scrollView)
        
        let header = UILabel(frame: CGRect(x: x, y: 20, width: screen.width, height: 30))
        header.text = "Expiring soon"
        header.font = UIFont(name: "Helvetica-Bold", size: 25)
        scrollView.addSubview(header)
        
        getLiveData { (food) in
            let frame = CGRect(x: self.x, y: 60 + (self.cellHeight + 20) * self.counter, width: self.screen.width - self.x * 2, height: self.cellHeight)
            // View to be added
            let myView = MyView(frame: frame, food: food)
            myView.tag = Int(self.counter)
            myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
            self.scrollView.contentSize = CGSize(width: self.screen.width, height: CGFloat(self.foodArray.count) * self.cellHeight + 290)
            self.counter += 1
            self.scrollView.addSubview(myView)
            print("Content height: \(self.scrollView.contentSize.height)")
        }
    }
    
    func reset() {
        self.counter = 0
        self.foodArray.removeAll()
        
        for view in self.scrollView.subviews {
            if view is MyView {
                view.removeFromSuperview()
            }
        }
    }
    
    func getLiveData(completion:@escaping (Food) -> Void) {
        
        db.collection("food").order(by: "expiryDate", descending: false).addSnapshotListener { (querySnapshot, error) in
            // Clean up the array and remove custom views to avoid duplicates
            self.reset()
            
            if let error = error {
                print("Error retrieving collection: \(error)")
            } else {
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents were found")
                    return
                }
                
                for doc in documents {
                    
                    let data = doc.data()
                    let id = doc.documentID
                    guard let name = data["name"] as? String else {continue}
                    guard let amount = data["amount"] as? Int else {continue}
                    guard let imageRef = data["image"] as? String else {continue}
                    guard let expiryDateStamp = data["expiryDate"] as? Timestamp else {continue}
                    let expiryDate = expiryDateStamp.dateValue()
                    guard let days = Date().compareDates(with: expiryDate) else {continue}
                    
                    print("outer exp: \(days)")
                    
                    // get subcollection
                    self.getCombiners(for: doc.documentID, completionBlock: { (combinersArray) in
                        if let desc = data["description"] as? String {
                            let food = Food(id: id, name: name, description: desc, amount: amount, expiry: days, imageRef: imageRef, combiners: combinersArray)
                            print("inner exp: \(food.expiry!)")
                            self.foodArray.append(food)
                            completion(food)
                        } else {
                            let food = Food(id: id, name: name, amount: amount, expiry: days, imageRef: imageRef)
                            print("inner exp: \(food.expiry!)")
                            self.foodArray.append(food)
                            completion(food)
                        }
                    })
                }
            }
        }
    }
    
    func getCombiners(for docID: String, completionBlock:@escaping ([[String: String]]) -> Void) {
        var combinersArray = [[String: String]]()
        self.db.collection("food").document(docID).collection("combiners").getDocuments(completion: { (snap, err) in
            if let error = err {
                print(error)
            } else {
                guard let docs = snap?.documents else {return}
                
                for d in docs {
                    let combiners = d.data()
                    let combinerImage = combiners["image"] as! String
                    let combinerTitle = combiners["name"] as! String
                    combinersArray.append([combinerImage: combinerTitle])
                }
                
                completionBlock(combinersArray)
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Implement filter
        for food in foodArray {
            if food.name.contains(searchText) {
                
            }
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let detailsVC = DetailsViewController()
        let index = sender.view!.tag
        
        guard let imageRef = foodArray[index].imageRef else { return }
        guard let combiners = foodArray[index].combiners else { return }
        guard let desc = foodArray[index].desc else { return }
        
        detailsVC.fullImageRef = imageRef
        detailsVC.desc = desc
        detailsVC.combiners = combiners
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc func longPressed(_ sender: UIButton) {
        // TODO: Long press activates a context menu with options (delete, move)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        let nextVC = AddViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
 
}

extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}

extension Date {
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func compareDates(with date: Date) -> Int? {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
}
