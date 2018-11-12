//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import GoneVisible

class LeftViewController: UITableViewController {
    
    var viewModel = HomeViewModel()
    private var titlesArray = ["",
                               "",
                               "Xin chào, Tùng!",
                               "",
                               "Trang chủ",
                               "Công việc của tôi",
                               "CV của tôi",
                               "Thông tin cá nhân",
                               "",
                               "",
                               "",
                               "",
                               "Đăng xuất",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_menuleft.png")!)
        viewModel.loadUserProfile(success: { [unowned self] fullname in
            self.titlesArray[2] = "Xin chào, \(fullname)"
            self.tableView.reloadData()
            }, failure: { error in
                print("User Profile Error: " + error)
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        if titlesArray[indexPath.row] == "" || indexPath.row == 2 {
            cell.icon.isHidden = true
            cell.bageLabel.isHidden = true
            cell.icon.gone()
            cell.titleLabel.font = cell.titleLabel.font.withSize(30)
//            let maxSize = CGSize(width: 180, height: 30)
//            let size = cell.titleLabel.sizeThatFits(maxSize)
//            cell.titleLabel.frame = CGRect(origin: CGPoint(x: 24, y: 8), size: size)
            cell.titleLabel.frame = CGRect(x: 24, y: 8, width:220, height: 30)
        }
        if indexPath.row == (titlesArray.count - 1){
            cell.bageLabel.isHidden = true
            cell.bageLabel.gone()
        }
        cell.bageLabel.layer.cornerRadius = 14
        cell.bageLabel.layer.borderColor = UIColor.clear.cgColor
        cell.bageLabel.layer.borderWidth = 5.0;
         cell.bageLabel.layer.masksToBounds = true
        
        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.separatorView.isHidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1)
        cell.isUserInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        
        if indexPath.row == 0 {
            if mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation {
                mainViewController.showRightView(animated: true, completionHandler: nil)
            }
            else {
                mainViewController.hideLeftView(animated: true, completionHandler: {
                    mainViewController.showRightView(animated: true, completionHandler: nil)
                })
            }
        }
        else if indexPath.row == 2 {
            let navigationController = mainViewController.rootViewController as! NavigationController
            let viewController: UIViewController!
            
            if navigationController.viewControllers.first is ViewController {
                viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
            }
            else {
                viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
            }
            
            navigationController.setViewControllers([viewController], animated: false)
            
            // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
            // You can use delay to avoid this and probably other unexpected visual bugs
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        else {
            if indexPath.row == 7
            {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "InfoAccountController")
                viewController.title = "\(titlesArray[indexPath.row])"
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(viewController, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }else{
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
                viewController.title = "\(titlesArray[indexPath.row])"
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(viewController, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }
        }
    }
    
}
