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
class CarrerOrCityController: UIViewController {
    var viewModel = ViewModel()
    var button = UIButton.init(type: .custom)
    var delegate: ChooseDelegate?
    var jobModel = HomeViewModel()
    var isCarrer: Bool = false
    var isStatus: Bool = false
    
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = false
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        if self.isCarrer == true {
            jobModel.getCarrer(success: {carrers in
                LoadingOverlay.shared.hideOverlayView()
                for i in 0...carrers.count-1 {
                    let viewModelItem = ViewModelItem(item: carrers[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.tableView?.dataSource = self.viewModel
                self.tableView?.reloadData()
            }, failure: {error in
                LoadingOverlay.shared.hideOverlayView()
            })
        } else if self.isStatus == true {
            
        } else {
            jobModel.getCity(success: {cities in
                LoadingOverlay.shared.hideOverlayView()
                for i in 0...cities.count-1 {
                    let viewModelItem = ViewModelItem(item: cities[i])
                    self.viewModel.items.append(viewModelItem)
                }
                self.tableView?.dataSource = self.viewModel
                self.tableView?.reloadData()
            }, failure: {error in
                LoadingOverlay.shared.hideOverlayView()
            })
        }
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .singleLine
        button.setTitle("Chọn", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action:#selector(self.chon(sender:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 10, y: 00, width: 80, height: 30) //CGRectMake(0, 0, 30, 30)
        button.titleLabel?.font =  UIFont(name: "Nunito-Bold", size: 18)
        let barButton = UIBarButtonItem.init(customView: button)
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Nunito-Bold", size: 18.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.green], for: .normal)
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc func chon(sender: UIBarButtonItem) {
        if viewModel.selectedItems.count > 0 {
            let myChoose = MyChoose(id: viewModel.selectedItems.map { $0.id }[0] , name: viewModel.selectedItems.map { $0.title }[0] )
            if delegate != nil {
                delegate?.didChoose(mychoose: myChoose)
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    
    
}
