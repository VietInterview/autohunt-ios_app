///**
/**
Created by: Hiep Nguyen Nghia on 2/1/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import MobileCoreServices

class AttachFileController: BaseViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var viewAttach: UIView!
    @IBOutlet weak var lblNameFileUpload: UILabel!
    
    var downloadTask: URLSessionDownloadTask?
    var backgroundSession: URLSession?
    
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
    
    @objc override func tappedMe(sender: UITapGestureRecognizer){
        
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
//        downloadFile(documentUrl: myURL)
//        openDocument(fileUrl: myURL)
        let size = sizeForLocalFilePath(filePath: url.path)
        var convertedValue: Double = Double(size)
        convertedValue /= 1024
        if convertedValue > 1024 {
            self.showMessage(title: "noti_title".localize(), message: "Tệp đính kèm phải dưới 1MB")
        }else{
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
    var documentInteractionController: UIDocumentInteractionController?
    
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
extension AttachFileController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
extension AttachFileController: URLSessionDownloadDelegate {
    
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
//            openDocument(fileUrl: destinationURL)
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
