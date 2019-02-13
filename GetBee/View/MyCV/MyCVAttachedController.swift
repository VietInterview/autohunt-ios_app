///**
/**
Created by: Hiep Nguyen Nghia on 2/12/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import SwipeCellKit
import Toaster

class MyCVAttachedController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NotifyConfirmAlertDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    var page:Int = 0
    var status:Int = -1
    let refreshControl = UIRefreshControl()
    var listCV2 = [CvList2]()
    var carrerId: Int = -1
    var cityId: Int = -1
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var vc = CarrerOrCityController()
    static let notificationName = Notification.Name("myNotificationAttach")
    var fromDate:String? = ""
    var toDate:String? = ""
    var searchString:String? = ""
    var listCVUpload = [CvListUpload]()
    var listCVUploadServer = [CvListUpload]()
    var saveResumeUpload = SaveResumeUpload()
    var downloadTask: URLSessionDownloadTask?
    var backgroundSession: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MyCVAttachedController.notificationName, object: nil)
    }
    @objc func sortArray() {
        self.page = 0
        self.getResumeUploaded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getResumeUploaded()
    }
    @objc func onNotification(notification:Notification)
    {
        var dict : Dictionary = notification.userInfo!
        let isCarrer : Bool = dict["isCarrer"] as? Bool ?? true
        let isCity : Bool = dict["isCity"] as? Bool ?? true
        let isStatus : Bool = dict["isStatus"] as? Bool ?? true
        let id: Int = dict["id"] as? Int ?? 0
        let strSearch: String = dict["name"] as? String ?? ""
        let strFromDate: String = dict["fromDate"] as? String ?? ""
        let strToDate: String = dict["toDate"] as? String ?? ""
        self.searchString = strSearch
        self.fromDate = strFromDate
        self.toDate = strToDate
        if isCarrer {
            self.carrerId = id
        } else if isStatus {
            self.status = id
        } else if isCity{
            self.cityId = id
        }
        getResumeUploaded()
    }
    func getResumeUploaded(){
        self.viewModel.getListCVUploaded(careerId: self.carrerId, fullName: self.searchString!, page: self.page, status: self.status, strToDate: self.toDate!, strfromDate: self.fromDate!, success: {saveResumeUpload in
            self.saveResumeUpload = saveResumeUpload
            if self.page == 0 {
                if #available(iOS 10.0, *) {
                    self.tableView.refreshControl?.endRefreshing()
                }else {
                    self.tableView.willRemoveSubview(self.refreshControl)
                }
                self.listCVUpload = saveResumeUpload.cvList!
            } else {
                self.listCVUpload .append(contentsOf: saveResumeUpload.cvList!)
            }
            self.listCVUploadServer = saveResumeUpload.cvList!
            self.tableView.reloadData()
        }, failure: {error in
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl?.endRefreshing()
            }else {
                self.tableView.willRemoveSubview(self.refreshControl)
            }
        })
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailResumeOriginalController") as! DetailResumeOriginalController
        vc.title = "Chi tiết hồ sơ gốc"
        vc.isAttached = true
        vc.cvUploadDetail = self.listCVUpload[indexPath.row-1]
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.listCVUpload.count - 1
        if  indexPath.row == lastElement {
            if self.listCVUpload.count >= 30 {
                page = page + 1
                self.getResumeUploaded()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 44
        } else {
            return 105
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCVUpload.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quantitycell", for: indexPath) as! SimpleCell
                if let total = saveResumeUpload.total {
                    cell.lblQuantity.text = "\(total) công việc được tìm thấy"
                    
                }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCVTableViewCell", for: indexPath) as! MyCVTableViewCell
            cell.btnStatus.setTitle(self.listCVUpload[indexPath.row-1].status! == 1 ? "Chưa hỗ trợ" : "Đã hỗ trợ", for: .normal)
            cell.btnStatus.setTitleColor(StringUtils.hexStringToUIColor(hex: self.listCVUpload[indexPath.row-1].status! == 1 ? "#FF5A5A" : "#3C84F7"), for: .normal)
            cell.btnStatus.addBorder(color: StringUtils.hexStringToUIColor(hex: self.listCVUpload[indexPath.row-1].status! == 1 ? "#FF5A5A" : "#3C84F7"), weight: 1)
            cell.btnStatus.addRadius(weight: 12, isBound: true)
            
            cell.lblName.text = self.listCVUpload[indexPath.row-1].fullName!
            cell.lblCarrer.text = StringUtils.checkEmpty(value:  self.listCVUpload[indexPath.row-1].careerName)
            cell.lblDateUpdate.text = self.listCVUpload[indexPath.row-1].createdDate!
            cell.delegate = self
            cell.contentView.shadowView(opacity: 8/100, radius: 10)
            return cell
        }
    }
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var documentInteractionController: UIDocumentInteractionController?
    func openDocument(fileUrl: URL) {
        documentInteractionController = UIDocumentInteractionController(url: fileUrl)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
//}
}
extension MyCVAttachedController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "NotifyConfirmAlert") as! NotifyConfirmAlert
            customAlert.id = self.listCVUpload[indexPath.row-1].id!
            customAlert.position = indexPath.row
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
        }
        let descriptor: ActionDescriptor = .trash
        configure(action: deleteAction, with: descriptor)
        let copy = SwipeAction(style: .default, title: nil) { action, indexPath in
            let url:String = "\(App.imgUrl)\(self.listCVUpload[indexPath.row-1].fileURL!)"
            debugLog(object: url)
            self.downloadFile(documentUrl: NSURL(string: url) as! URL)
        }
        copy.hidesWhenSelected = true
        let descriptorCopy: ActionDescriptor = .read
        configureCopy(action: copy, with: descriptorCopy)
        return [deleteAction,copy]
    }
    
    
    func okButtonTapped(id: Int, position: Int) {
        self.viewModel.deleteCV(cvId: id, success: { deleteCV in
            if deleteCV.count! > 0 {
                self.listCV2.remove(at: position)
                let toast = Toast(text: NSLocalizedString("delete_cv_success", comment: ""))
                toast.show()
            } else {
                let toast = Toast(text: NSLocalizedString("delete_cv_fail", comment: ""))
                toast.show()
                self.page = 0
                self.getResumeUploaded()
            }
        }, failure: {error in
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    
    func cancelButtonTapped() {
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    func configureCopy(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "download_resume")
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
        case .circular:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "delete_resume")!
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
        case .circular:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}

extension MyCVAttachedController {
    
    func downloadFile(documentUrl: URL) {
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self,
                                                  delegateQueue: OperationQueue.main)
        let request = URLRequest(url: documentUrl)
        downloadTask = backgroundSession?.downloadTask(with: request)
        downloadTask?.resume()
        // Show loading ở đây nhé
        UIApplication.showNetworkActivity()
    }
    
    // Hàm này để lưu file dựa theo tên file mà server trả về
    fileprivate func getDestinationFileUrl(response: URLResponse) -> URL {
        var docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = response.suggestedFilename ?? "file.pdf"
        docsURL.appendPathComponent(filename)
        return docsURL
    }
    
}
extension MyCVAttachedController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
extension MyCVAttachedController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        debugLog(object: "progress: \(progress)")
        // Hiển thị progress nếu thích :D
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Ẩn loading
        UIApplication.hideNetworkActivity()
        guard let response = downloadTask.response else {
            debugLog(object: downloadTask.error?.localizedDescription ?? "Loading file error.")
            return
        }
        let destinationURL = getDestinationFileUrl(response: response)
        
        // Đoạn này mình xoá file cũ đi nếu có (logic app mình thế ;) )
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }
        do {
            try fileManager.moveItem(at: location, to: destinationURL)
            
            // Mở file đã download được
            debugLog(object: destinationURL)
            openDocument(fileUrl: destinationURL)
        } catch {
            debugLog(object: error)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Ẩn loading
        UIApplication.hideNetworkActivity()
        debugLog(object: error != nil ? error!.localizedDescription : "not have error")
    }
    
}
