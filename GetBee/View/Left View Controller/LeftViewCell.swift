//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//
import UIKit
class LeftViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    @IBOutlet var bageLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel.alpha = highlighted ? 0.5 : 1.0
    }
    
}
