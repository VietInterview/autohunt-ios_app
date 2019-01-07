//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import GoneVisible

class LeftViewController: UITableViewController {
    
    var viewModel = HomeViewModel()
    private var dynamicTitlesArray = [LstAuthority]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getAccount()
    }
    func getAccount(){
        viewModel.loadAccount(success: {account in
            if self.dynamicTitlesArray.count > 0 {
                self.dynamicTitlesArray.removeAll()
            }
            let countMenuAvailable:Int = 5
            let countMenuDynamic:Int = account.lstMenuAuthority!.count
            let totalCountMenu = countMenuDynamic + countMenuAvailable
            for i in 0...totalCountMenu-1 {
                if i == 0 || i == 2 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: ""))
                } else if i == totalCountMenu-1 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "LOGOUT", id: 0, name: NSLocalizedString("logout", comment: "")))
                } else if i == 1 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: "Xin chào, Tùng!"))
                } else if i == totalCountMenu-2 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "PROFILE", id: 0, name: NSLocalizedString("info_acc", comment: "")))
                } else {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: account.lstMenuAuthority![i-3].code!, id: 0, name: account.lstMenuAuthority![i-3].name!))
                }
            }
            
            if let currentUser = UserDataManager.currentUser {
                self.setFullname(fullname: currentUser.fullNameColl)
            } else {
                self.viewModel.loadUserProfile(success: { userProfile in
                    self.setFullname(fullname: userProfile.fullNameColl)
                }, failure: { error in
                })
            }
        }, failure: {error in
            
        })
    }
    func setFullname(fullname:String?) {
        if let fullname = fullname {
            if fullname.count <= 12 {
                self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: "")) \(fullname)!")
            } else {
                self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: ""))")
                self.dynamicTitlesArray[2] = LstAuthority.init(code: "", id: 0, name: "  \(fullname)!")
            }
            self.tableView.reloadData()
        } else {
            self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: "")) ")
            self.tableView.reloadData()
        }
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicTitlesArray.count
    }
    var mPosition:Int = 3
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        if dynamicTitlesArray[indexPath.row].name! == "" || indexPath.row == 1 || indexPath.row == 2 {
            cell.icon.isHidden = true
            cell.icon.gone()
            cell.bageLabel.isHidden = true
            cell.titleLabel.font = cell.titleLabel.font.withSize(ScreenUtils.shared.getScreenWidth() == 414 ? 30 : 28)
            cell.titleLabel.frame = CGRect(x: 0, y: 8, width:220, height: 60)
        }
        if indexPath.row == (dynamicTitlesArray.count - 1){
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
        cell.titleLabel.text = dynamicTitlesArray[indexPath.row].name!
        cell.icon.image = self.setImageMenu(value:self.dynamicTitlesArray[indexPath.row].code!)
        return cell
    }
    func setImageMenu(value: String) -> UIImage {
        var image = UIImage()
        switch value {
        case "CTV_HOME_PAGE":
            image = UIImage(named: "home_menuleft")!
        case "CTV_JOB_SAVE":
            image = UIImage(named: "ic_job_menu")!
        case "CTV_JOB_SENT":
            image = UIImage(named: "ic_job_menu")!
        case "CTV_CV_SAVE":
            image = UIImage(named: "ic_cv_menu")!
        case "CTV_CV_SEND":
            image = UIImage(named: "ic_cv_menu")!
        case "LOGOUT":
            image = UIImage(named: "ic_shutdown")!
        case "PROFILE":
            image = UIImage(named: "ic_user_menu")!
        default:
            image = UIImage(named: "home_menuleft")!
        }
        return image
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return (ScreenUtils.shared.getScreenHeight()!/CGFloat(self.dynamicTitlesArray.count+30))
        }else if indexPath.row == self.dynamicTitlesArray.count - 1 {
            return 100
        } else {
            return (ScreenUtils.shared.getScreenHeight()!/CGFloat(self.dynamicTitlesArray.count))
        }
    }
    func replaceController(nameController:String, isLogout:Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: nameController)], animated: false)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        if isLogout{
            mainViewController.leftViewWidth = 0
        }
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.dynamicTitlesArray[indexPath.row].code {
        case "CTV_HOME_PAGE":
            replaceController(nameController: "ViewController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CTV_JOB_SAVE":
            replaceController(nameController: "MyJobController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case"CTV_JOB_SENT":
            replaceController(nameController: "MyJobController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CTV_CV_SAVE":
            replaceController(nameController: "MyCVController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CTV_CV_SEND":
            replaceController(nameController: "MyCVController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "LOGOUT":
            UserDataManager.deleteUser()
            SessionManager.deleteSession()
            replaceController(nameController: "SignInViewController", isLogout: true)
        case "PROFILE":
            if AccountManager.currentAccount!.type! == 2 {
                replaceController(nameController: "CustomerProfileController", isLogout: false)
            } else {
                replaceController(nameController: "InfoAccountController", isLogout: false)
            }
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CUSTOMER_HOME_PAGE":
            replaceController(nameController: "JobEmployerController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        default:
            replaceController(nameController: "ViewController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        }
    }
    
}
