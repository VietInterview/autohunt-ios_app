///**
/**
Created by: Hiep Nguyen Nghia on 10/14/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class CarrerOrCityController: UIViewController {
    var viewModel = ViewModel()
    var button = UIButton.init(type: .custom)
    
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.tintColor = UIColor.black
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .singleLine
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.button.setTitle("Chọn (\(self!.viewModel.selectedItems.count))", for: .normal)
        }
        
        button.setTitle("Chọn", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action:#selector(self.chon(sender:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 10, y: 00, width: 80, height: 30) //CGRectMake(0, 0, 30, 30)
        button.titleLabel?.font =  UIFont(name: "Nunito-Bold", size: 18)
        var barButton = UIBarButtonItem.init(customView: button)
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Nunito-Bold", size: 18.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.green],
                                          for: .normal)
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc func chon(sender: UIBarButtonItem) {
        print(viewModel.selectedItems.map { $0.title })
        tableView?.reloadData()
    }



}
