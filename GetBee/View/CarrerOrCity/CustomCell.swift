//
//  CustomCell.swift
//  TableViewWithMultipleSelection
//
//  Created by Stanislav Ostrovskiy on 5/22/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var item: ViewModelItem? {
        didSet {
            titleLabel?.text = item?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        selectionStyle = .none
    }
    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true{
            let yourImage: UIImage =  UIImage(named: "tickok")!
              imgCheck.isHidden = false
            imgCheck.image = yourImage
        } else {
            imgCheck.isHidden = true
        }
        // update UI
//        accessoryType = selected ? .checkmark : .none
    }
}
