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
        viewModel.loadUserProfile(success: { userProfile in
            if let fullname = userProfile.fullNameColl {
                self.titlesArray[2] = "Xin chào, \(fullname)"
                self.tableView.reloadData()
            } else {
                self.titlesArray[2] = "Xin chào, Unknown"
                self.tableView.reloadData()
            }
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
            //            if mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation {
            //                mainViewController.showRightView(animated: true, completionHandler: nil)
            //            }
            //            else {
            //                mainViewController.hideLeftView(animated: true, completionHandler: {
            //                    mainViewController.showRightView(animated: true, completionHandler: nil)
            //                })
            //            }
        }
        else if indexPath.row == 12 {
            UserDataManager.deleteUser()
            SessionManager.deleteSession()
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SignInViewController")], animated: false)
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            mainViewController.leftViewWidth = 0
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
        }
        else {
            if indexPath.row == 7
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "InfoAccountController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 6{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "MyCVController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 5{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "MyJobController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 12 {
                    UserDataManager.deleteUser()
                    SessionManager.deleteSession()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SignInViewController")], animated: false)
                
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
                
            } else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }
        }
    }
    
}
