///**
/**
 Created by: Hiep Nguyen Nghia on 12/21/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class InterviewProcessController: BaseViewController{
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var heightViewInfo: NSLayoutConstraint!
    @IBOutlet weak var viewInfo: UIView!
    
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.maxHeight = CGFloat(self.count * 70)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.heightViewInfo.constant = 190 + CGFloat(self.count * 70)
        self.viewInfo.layoutIfNeeded()
        self.viewInfo.setNeedsLayout()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    @IBAction func addInterview(_ sender: Any) {
        count = count + 1
        tableView.maxHeight = CGFloat(self.count * 70)
        self.heightViewInfo.constant = 190 + CGFloat(self.count * 70)
        self.viewInfo.layoutIfNeeded()
        self.viewInfo.setNeedsLayout()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row:count-1, section:0), at: .bottom, animated: true)
    }
    
    @IBAction func offerTouch(_ sender: Any) {
        debugLog(object: "Offer")
    }
    @IBAction func rejectTouch(_ sender: Any) {
        debugLog(object: "Reject")
    }
}
extension InterviewProcessController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterviewOfferCell", for: indexPath) as! InterviewOfferCell
        cell.lblRound.text = "Round\(self.count)"
        cell.lblDate.text = "28/12/2018"
        cell.lblStatus.text = "Đạt"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(controller: CreateEditInterviewController.init().setArgument(id: 1, value: "Thông tin phỏng vấn"))
   }
}
