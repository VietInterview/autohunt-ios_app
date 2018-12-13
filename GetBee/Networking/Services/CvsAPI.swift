///**
/**
 Created by: Hiep Nguyen Nghia on 11/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
import Alamofire
import UIKit

class CvsAPI{
    fileprivate static let cvsUrl = "/svccollaborator/api/cvs"
    fileprivate static let cvsUrlCus = "/svccustomer/api/"
    class func getMyCV(carrerId: Int, cityId: Int, page: Int,_ success: @escaping (_ myCv: MyCV) -> Void, failure: @escaping (_ error: Error) -> Void) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let url = cvsUrl + "/searchMyCv?carrerId=\(carrerId)&itemPerPage=30&cityId=\(cityId)&page=\(page)"
        APIClient.request(.get, url: url, success: { response, _ in
            if let myCV = try? newJSONDecoder().decode(MyCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(myCV)
            }
        }, failure: { error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getDetailCV(cvId: Int,_ success: @escaping (_ detailCV: DetailCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/getCvById/\(cvId)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let detailCV = try? newJSONDecoder().decode(DetailCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(detailCV)
            }
        }, failure: { error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getCVSaved(page: Int,_ success: @escaping (_ detailCV: ListCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/searchCvSave?itemPerPage=30&page=\(page)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let listCV = try? newJSONDecoder().decode(ListCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(listCV)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getCVSubmit(carrerID: Int, cityId: Int, statusId: Int, page: Int,_ success: @escaping (_ listCVSubmit: ListCVSubmit) -> Void, failure: @escaping (_ error: Error) -> Void) {
        var url:String = ""
        if statusId == 11 {
            url = cvsUrl + "/searchCvSubmit?careerId=\(carrerID)&cityId=\(cityId)&itemPerPage=30&page=\(page)"
        } else {
            url = cvsUrl + "/searchCvSubmit?careerId=\(carrerID)&cityId=\(cityId)&itemPerPage=30&page=\(page)&status=\(statusId)"
        }
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let listCVSubmit = try? newJSONDecoder().decode(ListCVSubmit.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(listCVSubmit)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func searchMyCV(carrerId: Int, cityId: Int, page: Int,_ success: @escaping (_ detailCV: ListCV) -> Void, failure: @escaping (_ error: Error) -> Void) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let url = cvsUrl + "/searchMyCv?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&page=\(page)"
        APIClient.request(.get, url: url, success: {response, _ in
            if let listCV = try? newJSONDecoder().decode(ListCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(listCV)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func deleteCV(cvId: Int,_ success: @escaping (_ deleteCV: DeleteCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let url = cvsUrl + "/delete/\(cvId)"
        APIClient.request(.delete, url: url, success: {response, _ in
            if let deleteCV = try? newJSONDecoder().decode(DeleteCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(deleteCV)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getResumesByJobCustomer(cvName:String, id:Int, page:Int, status:Int,_ success: @escaping (_ resumesByJobCustomer: ResumesByJobCustomer) -> Void, failure: @escaping (_ error: Error) -> Void){
        UIApplication.showNetworkActivity()
        let url = cvsUrlCus + "searchCusHomeCvByJob?itemPerPage=30&page=\(page)&id=\(id)&cvName=\(cvName)&status=\(status)"
        APIClient.request(.get, url: url, success: {response, _ in
            if let resumesByJobCus = try? newJSONDecoder().decode(ResumesByJobCustomer.self, from: response){
                UIApplication.hideNetworkActivity()
                success(resumesByJobCus)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func submitCV(cvId: Int, jobId: Int,type: Int,_ success: @escaping (_ submitCV: SubmitCV) -> Void, failure: @escaping (_ errorSubmitCV: String) -> Void){
        let url = cvsUrl + "/submitCvVesionMobile"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId,
            "type": type
            ] as [String : Any]
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request1(.post, url: url, params: parameters, success: { response, headers in
            if let submitCV = try? newJSONDecoder().decode(SubmitCV.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(submitCV)
            }
        }, failure: { errorSubmitCV, statusCode  in
            LoadingOverlay.shared.hideOverlayView()
            var dict : Dictionary = errorSubmitCV
            let errorString:String = dict["X-svcCollaboratorApp-error"] as? String ?? ""
            failure(errorString)
        })
    }
}
