///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import Alamofire

protocol ChooseDelegate{
    func didChoose(mychoose: MyChoose)
}
protocol ChooseMultiDelegate{
    func didChooseMulti(mychooseMulti: [MyChoose])
}
class CarrerOrCityController: BaseViewController,UITableViewDelegate {
    var viewModel = ViewModel()
    var button = UIButton.init(type: .custom)
    var delegate: ChooseDelegate?
    var delegateMulti: ChooseMultiDelegate?
    var jobModel = HomeViewModel()
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var isCity: Bool = false
    var isMultiChoice: Bool = false
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle(NSLocalizedString("choose", comment: ""), for: .normal)
        button.setTitleColor(StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
        button.addTarget(self, action:#selector(self.chon(sender:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 20, y: 00, width: 40, height: 30)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        let barButton = UIBarButtonItem.init(customView: button)
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 18.0)!,
            NSAttributedStringKey.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")], for: .normal)
        self.navigationItem.rightBarButtonItem = barButton
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 20)!]
    }
    var filterData = ViewModel()
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text! != "" {
            filterData.items = self.viewModel.items.filter {item in
                return item.title.lowercased().contains(textField.text!.lowercased())
            }
            self.tableView?.dataSource = filterData
            self.tableView?.reloadData()
        } else {
            self.filterData.items = self.viewModel.items
            self.tableView?.dataSource = filterData
            self.tableView?.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = self.isMultiChoice
        viewModel = ViewModel(isMulti: self.isMultiChoice)
        filterData = ViewModel(isMulti: self.isMultiChoice)
        if self.isCarrer == true {
            jobModel.getCarrer(success: {carrers in
                self.viewModel.items.removeAll()
                self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 0, name: NSLocalizedString("all_carrer", comment: ""))))
                for i in 0...carrers.count-1 {
                    let viewModelItem = ViewModelItem(item: carrers[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.filterData.items = self.viewModel.items
                self.tableView?.dataSource = self.filterData
                self.tableView?.reloadData()
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
            })
        } else if self.isStatus == true {
            self.viewModel.items.removeAll()
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 1, name: NSLocalizedString("sent", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 3, name: NSLocalizedString("seen", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 4, name: NSLocalizedString("not_accept", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 5, name: NSLocalizedString("invite_interview", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 6, name: NSLocalizedString("interviewd", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 7, name: NSLocalizedString("offered", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 8, name: NSLocalizedString("go_to_work", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 9, name: NSLocalizedString("contract", comment: ""))))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 11, name: NSLocalizedString("default_key", comment: ""))))
            self.filterData.items = self.viewModel.items
            self.tableView?.dataSource = self.filterData
            self.tableView?.reloadData()
        } else {
            jobModel.getCity(success: {cities in
                self.viewModel.items.removeAll()
                self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 0, name: NSLocalizedString("all_city", comment: ""))))
                for i in 0...cities.count-1 {
                    let viewModelItem = ViewModelItem(item: cities[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.filterData.items = self.viewModel.items
                self.tableView?.dataSource = self.filterData
                self.tableView?.reloadData()
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
            })
        }
        tableView?.delegate = filterData
        tableView?.separatorStyle = .singleLine
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugLog(object: [indexPath.row])
    }
    @objc func chon(sender: UIBarButtonItem) {
        if filterData.selectedItems.count > 0 {
            if self.isMultiChoice == false {
                let myChoose = MyChoose(id: filterData.selectedItems.map { $0.id }[0] , name: filterData.selectedItems.map { $0.title }[0], isStatus: self.isStatus, isCarrer: self.isCarrer, isCity: self.isCity )
                if delegate != nil {
                    delegate?.didChoose(mychoose: myChoose)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        } else if controller.isKind(of: MyCVController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        } else if controller.isKind(of: MyJobController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        } else if controller.isKind(of: InfoAccountController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            } else {
                var arrMyChoose = [MyChoose]()
                for i in 0...filterData.selectedItems.count-1{
                    let myChoose = MyChoose(id: filterData.selectedItems.map { $0.id }[i] , name: filterData.selectedItems.map { $0.title }[i], isStatus: self.isStatus, isCarrer: self.isCarrer, isCity: self.isCity )
                    arrMyChoose.append(myChoose)
                }
                if delegateMulti != nil {
                    delegateMulti?.didChooseMulti(mychooseMulti: arrMyChoose)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: InfoAccountController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    
}
