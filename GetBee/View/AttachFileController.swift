///**
/**
Created by: Hiep Nguyen Nghia on 2/1/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import MobileCoreServices
import Alamofire

class AttachFileController: BaseViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, ChooseMultiDelegate {

    @IBOutlet weak var viewAttach: UIView!
    @IBOutlet weak var lblNameFileUpload: UILabel!
    @IBOutlet weak var textFieldCarrer: UITextField!
    @IBOutlet weak var textFieldNumberPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var viewCarrer: UIView!
    
    var downloadTask: URLSessionDownloadTask?
    var backgroundSession: URLSession?
    var documentInteractionController: UIDocumentInteractionController?
    
    convenience init() {
        self.init(nibName: "AttachFileController", bundle: nil)
    }
    
    func setArgument() -> AttachFileController{
        let vc = self.assignValueToController(nameController: "AttachFileController") as! AttachFileController
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tải lên hồ sơ"
        showBackButton()
        showRightButton()
        self.viewAttach.addBorder(color: StringUtils.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        self.viewAttach.addRadius()
        self.textFieldCarrer.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "arrow_right")
        imageView.image = image
        imageView.contentMode = .center
        self.textFieldCarrer.rightView = imageView
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.viewCarrer.isUserInteractionEnabled = true
        self.viewCarrer.addGestureRecognizer(gestureSwift2AndHigher2)
        debugLog(object: "Điều đáng sợ trong đời".utf8DecodedString())
        debugLog(object: "Điều đáng sợ trong đời".utf8EncodedString())
    }
    
    @objc func someAction2(sender:UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.isCarrer = true
        vc.isStatus = false
        vc.isMultiChoice = true
        vc.isAttached = true
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
//    func didChoose(mychoose: MyChoose) {
//        if self.lstCarrer != nil {
//            if self.lstCarrer!.count == 0 {
//                lstCarrer!.append(LstCareerCVDto.init(id: mychoose.id, name: mychoose.name))
//            } else {
//                lstCarrer![0] = LstCareerCVDto.init(id: mychoose.id, name: mychoose.name)
//            }
//        } else {
//            lstCarrer = [LstCareerCVDto.init(id: mychoose.id, name: mychoose.name)]
//        }
//        self.textFieldCarrer.text = mychoose.name
//    }
    
    func didChooseMulti(mychooseMulti: [MyChoose]) {
        if self.lstCarrer != nil {
            self.lstCarrer!.removeAll()
            for i in 0...mychooseMulti.count-1 {
                self.lstCarrer!.append(LstCareerCVDto.init(id: mychooseMulti[i].id, name:  mychooseMulti[i].name))
            }
        } else {
            self.lstCarrer = [LstCareerCVDto]()
            for i in 0...mychooseMulti.count-1 {
                self.lstCarrer!.append(LstCareerCVDto.init(id: mychooseMulti[i].id, name:  mychooseMulti[i].name))
            }
        }
        var appenString: String = ""
        for i in 0...mychooseMulti.count - 1 {
            if i == mychooseMulti.count - 1{
                appenString.append(mychooseMulti[i].name)
            } else {
                appenString.append("\(mychooseMulti[i].name), ")
            }
        }
        self.textFieldCarrer.text = appenString
    }
    @IBAction func chooseFileTouch() {
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc",kUTTypeSpreadsheet as String, "org.openxmlformats.wordprocessingml.document"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    var lstCarrer:[LstCareerCVDto]?
    @objc override func tappedMe(sender: UITapGestureRecognizer){
        if self.lstCarrer == nil {
            self.lstCarrer = [LstCareerCVDto]()
        }
        if !self.textFieldFullName.text!.isEmpty && !self.textFieldEmail.text!.isEmpty && !self.textFieldNumberPhone.text!.isEmpty && self.mURL != nil && self.textFieldEmail.text!.isEmailFormatted() {
            let cvDto = CVDto(email: self.textFieldEmail.text, fullName: self.textFieldFullName.text, id: nil, lstCareer: self.lstCarrer!, phone: self.textFieldNumberPhone.text)
            let jsonEncoder = JSONEncoder()
            let jsonData = try! jsonEncoder.encode(cvDto)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            UIApplication.showNetworkActivity()
            Alamofire.upload(multipartFormData: { multipartFormData in
                let parameters = [
                    "cvDto": json!
                    ] as [String : Any]
                debugLog(object: parameters)
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let pdfData = try! Data(contentsOf: self.mURL!)
                let data : Data = pdfData
//                debugLog(object: self.lblNameFileUpload.text!)
                multipartFormData.append(data, withName: "file", fileName: "\(self.lblNameFileUpload.text!)", mimeType:"text/plain")
                
            }, to: "\(App.baseUrl)/svccollaborator/api/cv-uploads/save", method: .post, headers: ["Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)"],
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.response { [weak self] response in
                        guard self != nil else {
                            return
                        }
                        UIApplication.hideNetworkActivity()
                        debugLog(object: response.response!)
                        if response.response!.statusCode == 201 {
                            self?.showMessage(title: "Thông báo", message: "Upload thành công",handler:{ (action: UIAlertAction!) in
                                self!.navigationController?.backToViewController(vc: MyCVController.self)
                            }
                            )
                        } else {
                            self?.showMessage(title: "Thông báo", message: "Upload không thành công")
                        }
                    }
                case .failure(let encodingError):
                    UIApplication.hideNetworkActivity()
                    self.showMessage(title: "Thông báo", message: "Không kết nối được đến máy chủ, vui lòng thử lại sau.")
                    debugLog(object: encodingError)
                }
            })
        } else {
            self.showMessage(title: "noti_title".localize(), message: self.textFieldEmail.text! == "" ? "Nhập thông tin bắt buộc" : !self.textFieldEmail.text!.isEmailFormatted() ? "Hãy điền đúng định dạng Email" : self.mURL == nil ? "Hãy chọn tệp đính kèm" : "Nhập thông tin bắt buộc")
            self.textFieldFullName.addBorderRadius(color: self.textFieldFullName.text == "" ? StringUtils.hexStringToUIColor(hex: "#FF5A5A") : UIColor.clear, weight: 1)
            self.textFieldEmail.addBorderRadius(color: self.textFieldEmail.text == "" ? StringUtils.hexStringToUIColor(hex: "#FF5A5A") : UIColor.clear, weight: 1)
            self.textFieldEmail.addBorderRadius(color: !self.textFieldEmail.text!.isEmailFormatted() ? StringUtils.hexStringToUIColor(hex: "#FF5A5A") : UIColor.clear, weight: 1)
            self.textFieldNumberPhone.addBorderRadius(color: self.textFieldNumberPhone.text == "" ? StringUtils.hexStringToUIColor(hex: "#FF5A5A") : UIColor.clear, weight: 1)
            self.viewAttach.addBorderRadius(color: self.mURL == nil ? StringUtils.hexStringToUIColor(hex: "#FF5A5A") : StringUtils.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        }
    }
    var mURL:URL?
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        self.mURL = myURL
        let size = sizeForLocalFilePath(filePath: url.path)
        var convertedValue: Double = Double(size)
        convertedValue /= 1024
        if convertedValue > 1024 {
            self.viewAttach.addBorderRadius(color: StringUtils.hexStringToUIColor(hex: "#FF5A5A"), weight: 1)
            self.showMessage(title: "noti_title".localize(), message: "Tệp đính kèm phải dưới 1MB")
        }else{
            self.viewAttach.addBorderRadius(color: StringUtils.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
            self.lblNameFileUpload.text = myURL.lastPathComponent
        }
    }
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugLog(object: "view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func openDocument(fileUrl: URL) {
        documentInteractionController = UIDocumentInteractionController(url: fileUrl)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    func sizeForLocalFilePath(filePath: String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
}
extension AttachFileController {
    func downloadFile(documentUrl: URL) {
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        let request = URLRequest(url: documentUrl)
        downloadTask = backgroundSession?.downloadTask(with: request)
        downloadTask?.resume()
        UIApplication.showNetworkActivity()
    }
    
    fileprivate func getDestinationFileUrl(response: URLResponse) -> URL {
        var docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = response.suggestedFilename ?? "file.pdf"
        docsURL.appendPathComponent(filename)
        return docsURL
    }
    
}
extension AttachFileController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
extension AttachFileController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        debugLog(object: "progress: \(progress)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        UIApplication.hideNetworkActivity()
        guard let response = downloadTask.response else {
            debugLog(object: downloadTask.error?.localizedDescription ?? "Loading file error.")
            return
        }
        let destinationURL = getDestinationFileUrl(response: response)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }
        do {
            try fileManager.moveItem(at: location, to: destinationURL)
            debugLog(object: destinationURL)
            openDocument(fileUrl: destinationURL)
        } catch {
            debugLog(object: error)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        UIApplication.hideNetworkActivity()
        debugLog(object: error != nil ? error!.localizedDescription : "not have error")
    }
    
}
