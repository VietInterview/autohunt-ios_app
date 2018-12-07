//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import GoneVisible

class LeftViewController: UITableViewController {
    
    var viewModel = HomeViewModel()
    private var titlesArray = ["", "Xin chào, Tùng!", "",
                               NSLocalizedString("home", comment: ""),
                               NSLocalizedString("my_job", comment: ""),
                               NSLocalizedString("mycv", comment: ""),
                               NSLocalizedString("info_acc", comment: ""),  "",  "", "",  "",
                               NSLocalizedString("logout", comment: ""),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = UserDataManager.currentUser {
            if let fullname = currentUser.fullNameColl {
                if fullname.count <= 4 {
                    self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) \(fullname)!"
                } else {
                    self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) \(fullname)!"
                }
                self.tableView.reloadData()
            } else {
                self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) "
                self.tableView.reloadData()
            }
        } else {
            viewModel.loadUserProfile(success: { userProfile in
                if let fullname = userProfile.fullNameColl {
                    if fullname.count <= 4 {
                        self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) \(fullname)!"
                    } else {
                        self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) \(fullname)!"
                    }
                    self.tableView.reloadData()
                } else {
                    self.titlesArray[1] = "\(NSLocalizedString("greeting", comment: "")) "
                    self.tableView.reloadData()
                }
            }, failure: { error in
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
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
    var mPosition:Int = 3
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        if titlesArray[indexPath.row] == "" || indexPath.row == 1 || indexPath.row == 2 {
            cell.icon.isHidden = true
            //            cell.icon.gone()
            cell.bageLabel.isHidden = true
            cell.titleLabel.font = cell.titleLabel.font.withSize(ScreenUtils.shared.getScreenWidth() == 414 ? 30 : 28)
            cell.titleLabel.frame = CGRect(x: 0, y: 8, width:220, height: 60)
        }
        if indexPath.row == (titlesArray.count - 1){
            cell.bageLabel.isHidden = true
            cell.bageLabel.gone()
        }
        if UserDefaults.standard.integer(forKey: "position") == indexPath.row {
            cell.icon.backgroundColor = UIColor.gray
            cell.titleLabel.backgroundColor = UIColor.gray
        } else {
            cell.icon.backgroundColor = UIColor.clear
            cell.titleLabel.backgroundColor = UIColor.clear
        }
        cell.bageLabel.layer.cornerRadius = 14
        cell.bageLabel.layer.borderColor = UIColor.clear.cgColor
        cell.bageLabel.layer.borderWidth = 5.0;
        cell.bageLabel.layer.masksToBounds = true
        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.icon.image = self.setImageMenu(value: indexPath.row)
        return cell
    }
    func setBackground(value:Int) {
        
    }
    func setImageMenu(value: Int) -> UIImage {
        var image = UIImage()
        switch value {
        case 3:
            image = UIImage(named: "home_menuleft")!
        case 4:
            image = UIImage(named: "ic_job_menu")!
        case 5:
            image = UIImage(named: "ic_cv_menu")!
        case 6:
            image = UIImage(named: "ic_user_menu")!
        case 11:
            image = UIImage(named: "ic_shutdown")!
        default:
            image = UIImage(named: "home_menuleft")!
        }
        return image
    }
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 1) ? 75.0 : 44.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        }
        if indexPath.row == 11 {
            UserDataManager.deleteUser()
            SessionManager.deleteSession()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
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
            if indexPath.row == 6
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "InfoAccountController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 5{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "MyCVController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 4{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "MyJobController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }else if indexPath.row == 11 {
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
