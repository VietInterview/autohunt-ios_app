//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import JJFloatingActionButton
import GoneVisible

class ViewController : UIViewController, UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate{
    @IBOutlet weak var btnactionSearch: UIBarButtonItem!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var labelQuantityJOb: UILabel!
    @IBOutlet weak var tableViewJob: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var quantityView: UIView!
    
    var isSearch = false
    var isFilter = false
      let actionButton = JJFloatingActionButton()
    
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 139, height: 39))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Logo.png")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        actionButton.buttonImage = UIImage(named: "float_button")
        actionButton.buttonColor = .clear
        if #available(iOS 11.0, *) {
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: (UIScreen.main.bounds.width / 2.5) * (-1)).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        searchView.isHidden=true
        searchView.gone()
        conditionView.isHidden=true
        conditionView.gone()
    }
    @IBAction func actionSearch(_ sender: Any) {
        if isSearch == false {
            btnactionSearch.image = UIImage(named: "tick_black.png")
            searchView.isHidden=false
            searchView.visible()
            if isFilter == false {
                conditionView.isHidden=true
                conditionView.gone()
            } else {
                conditionView.isHidden=false
                conditionView.visible()
            }
            isSearch=true
        } else {
            btnactionSearch.image = UIImage(named: "search.png")
            searchView.isHidden=true
            searchView.gone()
            UIView.animate(withDuration: 0.3) { self.searchView.layoutIfNeeded() }
            conditionView.isHidden=true
            conditionView.gone()
            isFilter = false
            isSearch = false
        }
    }
    
    @IBAction func filterTouchUp(_ sender: Any) {
        if isFilter == false {
            btnFilter.setImage(UIImage(named: "filter_black.png"), for: .normal)
            isFilter = true
            conditionView.isHidden=false
            conditionView.visible()
        } else {
            btnFilter.setImage(UIImage(named: "filter_gray.png"), for: .normal)
            isFilter = false
            conditionView.isHidden=true
            conditionView.gone()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 240.0;
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
   quantityView.isHidden = false
            quantityView.visible()
            self.actionButton.visible()
        } else {
            quantityView.gone()
            self.actionButton.gone()
            quantityView.isHidden = true
        }
        
    }
}
