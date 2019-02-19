///**
/**
 Created by: Hiep Nguyen Nghia on 1/7/19
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class WelfareTableCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate  {
    
    var dataArr:[String] = []
    @IBOutlet weak var tableWelfare: SelfSizedTableView!
     @IBOutlet weak var heightTableWelfare: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUpTable(){
        tableWelfare.delegate = self
        tableWelfare.dataSource = self
        self.tableWelfare.estimatedRowHeight = 50
        self.tableWelfare.rowHeight = UITableViewAutomaticDimension
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func registerTableView(dataArr:[String]){
        self.dataArr = dataArr
        self.tableWelfare.dataSource = self
        tableWelfare.delegate = self
        tableWelfare.maxHeight = CGFloat(self.dataArr.count * Int(80))
        self.heightTableWelfare.constant = CGFloat(self.dataArr.count * Int(80))
        self.tableWelfare.layoutIfNeeded()
        self.tableWelfare.setNeedsLayout()
        if self.dataArr.count>0 {
            tableWelfare.scrollToRow(at: IndexPath(row:self.dataArr.count-1, section:0), at: .bottom, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WelfareCell", for: indexPath) as? WelfareCell
        
        cell!.lblWelfare.text = "\(dataArr[indexPath.row])"
        cell!.lblWelfare.padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        cell!.lblWelfare.addRadius()
        cell!.lblWelfare.addBorder(color: StringUtils.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        cell!.isUserInteractionEnabled = false
        return cell!
    }
}
extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}
