///**
/**
Created by: Hiep Nguyen Nghia on 2/1/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class NotifyConfirmAlert: UIViewController {

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    var delegate: NotifyConfirmAlertDelegate?
    var id:Int?
    var position:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        animateView()
    }
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }

    @IBAction func onAcceptTapped(_ sender: Any) {
        delegate?.okButtonTapped(id: self.id != nil ? self.id! : -1, position: self.position != nil ? self.position! : -1)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onCancelTapped(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
}
