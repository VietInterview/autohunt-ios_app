//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import GoneVisible

class LeftViewController: UITableViewController {
    
    var viewModel = HomeViewModel()
    private var dynamicTitlesArray = [LstAuthority]()
    let totalCountMenu = 13
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAccount()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func getAccount(){
        viewModel.loadAccount(success: {account in
            if self.dynamicTitlesArray.count > 0 {
                self.dynamicTitlesArray.removeAll()
            }
            var numbers = [String]()
            var names = [String]()
            if account.lstMenuAuthority!.count > 0 {
                for i in 0...account.lstMenuAuthority!.count-1 {
                    numbers.append(account.lstMenuAuthority![i].code!)
                    names.append(account.lstMenuAuthority![i].name!)
                }
            }
            let unique = numbers.removingDuplicates()
            let name = names.removingDuplicates()
            for i in 0...self.totalCountMenu-1 {
                if i == 0 || i == 2 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: ""))
                } else if i == self.totalCountMenu-1 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "LOGOUT", id: 0, name: NSLocalizedString("logout", comment: "")))
                } else if i == 1 {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: "Xin chào, Tùng!"))
                } else if i == (3+unique.count) {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "PROFILE", id: 0, name:AccountManager.currentAccount!.type! == 2 ? "Thông tin nhà tuyển dụng": NSLocalizedString("info_acc", comment: "")))
                } else if i >= 3 && i <= (3+unique.count-1){
                    if unique.count > 0 {
                        if unique[i-3] == "CUSTOMER_HOME_PAGE" {
                            self.dynamicTitlesArray.append(LstAuthority.init(code: unique[i-3], id: 0, name: "Quản lý công việc"))
                        } else if unique[i-3] == "CTV_JOB_SAVE" {
                            self.dynamicTitlesArray.append(LstAuthority.init(code: unique[i-3], id: 0, name: "Công việc của tôi"))
                        }  else if unique[i-3] == "CTV_JOB_SENT" {
                            
                        }  else if unique[i-3] == "CTV_CV_SAVE" {
                            self.dynamicTitlesArray.append(LstAuthority.init(code: unique[i-3], id: 0, name: "Hồ sơ của tôi"))
                        }  else if unique[i-3] == "CTV_CV_SEND" {
                            
                        } else {
                            self.dynamicTitlesArray.append(LstAuthority.init(code: unique[i-3], id: 0, name: name[i-3]))
                        }
                    } else {
                        self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: ""))
                    }
                } else {
                    self.dynamicTitlesArray.append(LstAuthority.init(code: "", id: 0, name: ""))
                }
            }
            if let currentUser = UserDataManager.currentUser {
                if AccountManager.currentAccount!.type! == 2 {
                    self.setFullname(fullname: AccountManager.currentAccount!.firstName!)
                } else {
                    self.setFullname(fullname: currentUser.fullNameColl)
                }
            } else {
                if account.type! == 7 {
                    self.viewModel.loadUserProfile(success: { userProfile in
                        self.setFullname(fullname: userProfile.fullNameColl)
                    }, failure: { error in
                        self.showMessageErrorApi()
                    })
                } else if account.type! == 2 {
                    self.setFullname(fullname: account.firstName)
                } else {
                    self.viewModel.loadUserProfile(success: { userProfile in
                        self.setFullname(fullname: userProfile.fullNameColl)
                    }, failure: { error in
                        self.showMessageErrorApi()
                    })
                }
            }
        }, failure: {error in
        })
    }
    func setFullname(fullname:String?) {
        if let fullname = fullname {
            if ScreenUtils.shared.getScreenWidth() == 414 {
                if fullname.count <= 12 {
                    self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: "")) \(fullname)!")
                } else {
                    self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: ""))")
                    self.dynamicTitlesArray[2] = LstAuthority.init(code: "", id: 0, name: "  \(fullname)!")
                }
            } else {
                if fullname.count <= 7 {
                    self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: "")) \(fullname)!")
                } else {
                    self.dynamicTitlesArray[1] = LstAuthority.init(code: "", id: 0, name: "  \(NSLocalizedString("greeting", comment: ""))")
                    self.dynamicTitlesArray[2] = LstAuthority.init(code: "", id: 0, name: "  \(fullname)!")
                }
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
            cell.isUserInteractionEnabled = false
            cell.bageLabel.isHidden = true
            cell.titleLabel.font = cell.titleLabel.font.withSize(ScreenUtils.shared.getScreenWidth() == 414 ? 30 : 28)
            cell.titleLabel.frame = CGRect(x: 0, y: 8, width:220, height: 60)
        }
        if indexPath.row == (self.totalCountMenu-3){
            cell.bageLabel.isHidden = true
            cell.bageLabel.gone()
        }
        if UserDefaults.standard.integer(forKey: "position") == indexPath.row {
            cell.icon.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#4e6071")
            cell.titleLabel.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#4e6071")
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
        } else if indexPath.row == (self.totalCountMenu-3) {
             return (ScreenUtils.shared.getScreenHeight()!/CGFloat(self.dynamicTitlesArray.count))
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
            replaceController(nameController: AccountManager.currentAccount!.type! == 2 ? "" : "ViewController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CTV_JOB_SAVE":
            replaceController(nameController: "MyJobController", isLogout: false)
            UserDefaults.standard.set(indexPath.row, forKey: "position")
        case "CTV_JOB_SENT":
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
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
