//
//  FoodOrganizer.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

@IBDesignable class MyView: UIView {
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var amountChanger: UIStepper!
    @IBOutlet weak var deleteButton: UIButton!
    
    var view: UIView!
    var nibName: String = "MyView"
    var food: Food!
    
    let database = Firestore.firestore()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, food: Food) {
        self.init(frame: frame)
        setup()
        
        self.food = food
        imageHolder.sd_setImage(with: Storage.storage().reference(withPath: food.imageRef!))
        imageHolder.layer.cornerRadius = 8
        imageHolder.clipsToBounds = true
        nameLabel.text = food.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        amountLabel.text = "Amount left: \(food.amount!)"
        amountChanger.value = Double(food.amount!)
        dueLabel.text = "Expires in \(food.expiry!) days"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        database.collection("food").document(food.id).delete { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    @IBAction func amountChanged(_ sender: UIStepper) {
        database.collection("food").document(food.id).updateData([
            "amount": Int(sender.value)
        ]) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    func setup() {
        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.init(red: 29/255, green: 209/255, blue: 65/255, alpha: 1).cgColor
        
        addSubview(view)
    }
    
}
