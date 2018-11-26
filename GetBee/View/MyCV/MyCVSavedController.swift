///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import SwipeCellKit
import Toaster

class MyCVSavedController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    var listCV = ListCV()
    var listCVServer = [CvList2]()
    var listCV2 = [CvList2]()
    var page: Int = 0
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var carrerId: Int = -1
    var cityId: Int = -1
    var homeViewModel = HomeViewModel()
    var vc = CarrerOrCityController()
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = false
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var usesTallCells = false
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var quantityView: UIView!
    static let notificationName = Notification.Name("myNotificationName")
    @IBOutlet weak var mCVSavedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.mCVSavedTableView.refreshControl = refreshControl
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MyCVSavedController.notificationName, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.page = 0
        if carrerId != -1 || cityId != -1{
            self.searchMyCV(carrerId: self.carrerId, cityId: self.cityId)
        } else {
            self.getMyCVSaved()
        }
    }
    func searchMyCV(carrerId: Int, cityId: Int) {
        self.homeViewModel.searchMyCV(carrerId: self.carrerId, cityId: self.cityId, page: self.page, success: {listCV in
            if self.page == 0 {
                self.listCV = listCV
                self.listCV2 = listCV.cvList!
                if #available(iOS 10.0, *) {
                    self.quantityView.isHidden = false
                    self.quantityView.visible()
                    self.mCVSavedTableView.refreshControl?.endRefreshing()
                }
            } else {
                self.listCV2.append(contentsOf: listCV.cvList!)
                self.listCV.cvList!.append(contentsOf: listCV.cvList!)
            }
            self.lblQuantity.text = "\(listCV.total!) hồ sơ được tìm thấy"
            self.listCVServer = listCV.cvList!
            self.mCVSavedTableView.reloadData()
        }, failure: {error in
            
        })
    }
    func getMyCVSaved(){
        self.homeViewModel.getListCVSaved(page: self.page, success: { listCV in
            if self.page == 0 {
                self.listCV = listCV
                self.listCV2 = listCV.cvList!
                if #available(iOS 10.0, *) {
                    self.mCVSavedTableView.refreshControl?.endRefreshing()
                }
            } else {
                self.listCV2.append(contentsOf: listCV.cvList!)
                self.listCV.cvList!.append(contentsOf: listCV.cvList!)
            }
            self.lblQuantity.text = "\(listCV.total!) hồ sơ được tìm thấy"
            self.listCVServer = listCV.cvList!
            self.mCVSavedTableView.reloadData()
        }, failure: {error in
            
        })
    }
    @objc func refresh() {
        self.page = 0
        if carrerId != -1 || cityId != -1{
            self.searchMyCV(carrerId: self.carrerId, cityId: self.cityId)
        } else {
            self.getMyCVSaved()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.listCV.cvList!.count - 1
        if  indexPath.row == lastElement {
            if self.listCVServer.count >= 30 {
                page = page + 1
                if carrerId != -1 && cityId != -1{
                    self.getMyCVSaved()
                } else {
                    self.searchMyCV(carrerId: self.carrerId, cityId: self.cityId)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCVController") as! DetailCVController
        vc.title = "Chi tiết Hồ sơ"
        vc.cvId = self.listCV2[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listCV2.count > 0 {
            return self.listCV2.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCVTableViewCell", for: indexPath) as! MyCVTableViewCell
        cell.delegate = self 
        cell.lblName.text = self.listCV.cvList![indexPath.row].fullName!
        cell.lblDateUpdate.text = "Ngày nộp: \(DateUtils.shared.convertToShowFormatDate(dateString: self.listCV.cvList![indexPath.row].updatedDate!))"
        cell.lblCarrer.text = self.listCV.cvList![indexPath.row].careerName!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            quantityView.isHidden = false
            quantityView.visible()
        } else {
            quantityView.gone()
            quantityView.isHidden = true
        }
    }
    @objc func onNotification(notification:Notification)
    {
        var dict : Dictionary = notification.userInfo!
        let isCarrer : Bool = dict["isCarrer"] as? Bool ?? true
        let isCity : Bool = dict["isCity"] as? Bool ?? true
        let id: Int = dict["id"] as? Int ?? 0
        if isCarrer {
            self.carrerId = id
        } else if isCity{
            self.cityId = id
        }
    }
}
extension MyCVSavedController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
        //            self.listCV2.remove(at: indexPath.row)
        //        }
        //        self.configure(action: delete, with: .trash)
        //        self.homeViewModel.deleteCV(cvId: self.listCV2[indexPath.row].id!, success: { deleteCV in
        //            if deleteCV.count! == 0 {
        //
        //            } else {
        //
        //            }
        //        }, failure: {error in
        //
        //        })
        //        return [delete]
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let id = self.listCV2[indexPath.row].id!
            self.listCV2.remove(at: indexPath.row)
            self.homeViewModel.deleteCV(cvId: id, success: { deleteCV in
                if deleteCV.count! > 0 {
                    let toast = Toast(text: "Xóa thành công")
                    toast.show()
                } else {
                    let toast = Toast(text: "Không thể xóa")
                    toast.show()
                    self.page = 0
                    if self.carrerId != -1 || self.cityId != -1{
                        self.searchMyCV(carrerId: self.carrerId, cityId: self.cityId)
                    } else {
                        self.getMyCVSaved()
                    }
                }
            }, failure: {error in
                
            })
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = UIImage(named: "delete")!
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}
