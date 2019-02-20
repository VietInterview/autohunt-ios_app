//
//  ViewModel.swift
//  TableViewWithMultipleSelection
//
//  Created by Stanislav Ostrovskiy on 5/22/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

var dataArray = [CarrerListElement]()

class ViewModelItem {
    private var item: CarrerListElement
    
    var isSelected = false
    var id: Int {
        return item.id!
    }
    var title: String {
        return item.name!
    }
    
    init(item: CarrerListElement) {
        self.item = item
    }
}

class ViewModel: NSObject {
    var lastContentOffset: CGFloat = 0
    var items = [ViewModelItem]()
    var vc:CarrerOrCityController?
    var isMulti = Bool()
    var isAttached = Bool()
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items = dataArray.map { ViewModelItem(item: $0) }
    }
    init(isMulti: Bool, isAttached:Bool) {
        self.isMulti = isMulti
        self.isAttached = isAttached
    }
}

extension ViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            let carrerListElement = CarrerListElement(id: items[indexPath.row].id,name: items[indexPath.row].title)
            cell.item = carrerListElement
            
            // select/deselect the cell
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
        if isMulti {
            if !self.isAttached {
                if indexPath.row == 0 {
                    items[0].isSelected = false
                    if items.count > 1 {
                        for i in 1...items.count-1 {
                            items[i].isSelected = true
                        }
                    } else {
                        
                    }
                } else {
                    items[0].isSelected = false
                }
            }
        }
        didToggleSelection?(!selectedItems.isEmpty)
    }
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.vc!.view.endEditing(true)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.vc!.view.endEditing(true)
        } else {
            self.vc!.view.endEditing(true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.isAttached {
            if selectedItems.count > 2 {
                return nil
            }
        }
        return indexPath
    }
}
