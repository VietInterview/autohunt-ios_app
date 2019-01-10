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
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style , reuseIdentifier: reuseIdentifier)
//        setUpTable()
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        setUpTable()
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        setUpTable()
    }
    func setUpTable(){
        tableWelfare.delegate = self
        tableWelfare.dataSource = self
        self.tableWelfare.estimatedRowHeight = 60
        self.tableWelfare.rowHeight = UITableViewAutomaticDimension
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func registerTableView(dataArr:[String]){
        self.dataArr = dataArr
        self.tableWelfare.dataSource = self
        tableWelfare.delegate = self
        tableWelfare.maxHeight = CGFloat(self.dataArr.count * Int(60))
        self.heightTableWelfare.constant = CGFloat(self.dataArr.count * Int(60))
        self.tableWelfare.layoutIfNeeded()
        self.tableWelfare.setNeedsLayout()
        tableWelfare.scrollToRow(at: IndexPath(row:self.dataArr.count-1, section:0), at: .bottom, animated: true)
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
        cell!.lblWelfare.text = "   \(dataArr[indexPath.row])"
        cell!.lblWelfare.addRadius()
        cell!.lblWelfare.addBorder(color: StringUtils.shared.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        cell!.isUserInteractionEnabled = false
        return cell!
    }
}
