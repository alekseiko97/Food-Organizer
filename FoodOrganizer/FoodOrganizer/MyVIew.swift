//
//  FoodOrganizer.swift
//  FoodOrganizer
//
//  Created by Aleksey Moskaljuk on 2019-02-13.
//  Copyright © 2019 Aleksei Moskaljuk. All rights reserved.
//

import UIKit

@IBDesignable class MyView: UIView {
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    
    var view: UIView!
    var nibName: String = "MyView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame:CGRect, food: Food) {
        self.init(frame: frame)
        setup()
        
        imageHolder.image = food.image
        imageHolder.layer.cornerRadius = 8
        imageHolder.clipsToBounds = true
        nameLabel.text = food.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        amountLabel.text = "Amount left: " + String(food.amount)
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
    
    func setup() {
        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.green.cgColor
        
        addSubview(view)
    }
    
}
