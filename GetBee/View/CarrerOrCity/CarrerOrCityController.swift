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
class CarrerOrCityController: UIViewController,UITableViewDelegate {
    var viewModel = ViewModel()
    var button = UIButton.init(type: .custom)
    var delegate: ChooseDelegate?
    var delegateMulti: ChooseMultiDelegate?
    var jobModel = HomeViewModel()
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var isCity: Bool = false
    var isMultiChoice: Bool = false
    
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        button.setTitle("Chọn", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action:#selector(self.chon(sender:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 20, y: 00, width: 40, height: 30) //CGRectMake(0, 0, 30, 30)
        button.titleLabel?.font =  UIFont(name: "Nunito-Bold", size: 18)
        let barButton = UIBarButtonItem.init(customView: button)
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Nunito-Bold", size: 18.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.green], for: .normal)
        self.navigationItem.rightBarButtonItem = barButton
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = self.isMultiChoice
        viewModel = ViewModel(isMulti: self.isMultiChoice)
        if self.isCarrer == true {
            jobModel.getCarrer(success: {carrers in
                self.viewModel.items.removeAll()
                self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 0, name: "Tất cả ngành nghề")))
                for i in 0...carrers.count-1 {
                    let viewModelItem = ViewModelItem(item: carrers[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.tableView?.dataSource = self.viewModel
                self.tableView?.reloadData()
            }, failure: {error in
            })
        } else if self.isStatus == true {
            self.viewModel.items.removeAll()
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 1, name: "Đã gửi")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 3, name: "Đã xem")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 4, name: "Từ chối")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 5, name: "Mời phỏng vấn")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 6, name: "Đã phỏng vấn")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 7, name: "Được tuyển dụng")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 8, name: "Đi làm")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 9, name: "Ký hợp đồng")))
            self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 11, name: "Mặc định")))
            self.tableView?.dataSource = self.viewModel
            self.tableView?.reloadData()
        } else {
            jobModel.getCity(success: {cities in
                self.viewModel.items.removeAll()
                self.viewModel.items.append(ViewModelItem(item: CarrerListElement(id: 0, name: "Tất cả thành phố")))
                for i in 0...cities.count-1 {
                    let viewModelItem = ViewModelItem(item: cities[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.tableView?.dataSource = self.viewModel
                self.tableView?.reloadData()
            }, failure: {error in
            })
        }
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .singleLine
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugLog(object: [indexPath.row])
    }
    @objc func chon(sender: UIBarButtonItem) {
        if viewModel.selectedItems.count > 0 {
            if self.isMultiChoice == false {
                let myChoose = MyChoose(id: viewModel.selectedItems.map { $0.id }[0] , name: viewModel.selectedItems.map { $0.title }[0], isStatus: self.isStatus, isCarrer: self.isCarrer, isCity: self.isCity )
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
                for i in 0...viewModel.selectedItems.count-1{
                    let myChoose = MyChoose(id: viewModel.selectedItems.map { $0.id }[i] , name: viewModel.selectedItems.map { $0.title }[i], isStatus: self.isStatus, isCarrer: self.isCarrer, isCity: self.isCity )
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
