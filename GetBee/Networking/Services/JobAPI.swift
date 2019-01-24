///**
/**
 Created by: Hiep Nguyen Nghia on 11/7/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
import Alamofire
import UIKit

class JobAPI {
    fileprivate static let collUrl = "/svccollaborator/api/jobs"
    fileprivate static let customerUrl = "/svccustomer/api"
    class func getSearchJob(carrerId: Int, jobTitle: String, cityId: Int, page: Int,_ success: @escaping (_ job: Job) -> Void, failure: @escaping (_ error: Error) -> Void) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let url = collUrl + "/searchJob?careerId=\(carrerId)&jobtile=\(jobTitle)&itemPerPage=30&cityId=\(cityId)&page=\(page)"
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        APIClient.request(.get, url: encodedURL, success: { response, _,status  in
            LoadingOverlay.shared.hideOverlayView()
            if let job = try? JSONDecoder().decode(Job.self, from: response){
                success(job)
            }
        }, failure: { error,response,status in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getDetailJob(jobId: Int,_ success: @escaping (_ detailJob: JobDetail) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/getJobDetail?jobId=\(jobId)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _,status in
            if let detailJob = try? JSONDecoder().decode(JobDetail.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(detailJob)
            }
        }, failure: {error,response ,status in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getCarrerList(_ success: @escaping (_ carrer: CarrerList) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let baseUrl = App.baseUrl + "/svccollaborator/api/mstCareer"
        let headers = [
            "Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)",
            "Content-Type": "application/json"
        ]
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseCarrerList { response in
            print(response)
            if let carrerList = response.result.value {
                LoadingOverlay.shared.hideOverlayView()
                success(carrerList)
            } else {
                LoadingOverlay.shared.hideOverlayView()
                failure(response.error!)
            }
        }
    }
    class func getListRejectReason(_ success: @escaping (_ carrer: ListRejectReason) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let baseUrl = App.baseUrl + "/svccollaborator/api/getListRejectReason"
        let headers = [
            "Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)",
            "Content-Type": "application/json"
        ]
        UIApplication.showNetworkActivity()
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseListRejectReason { response in
            print(response)
            if let listRejectReason = response.result.value {
                UIApplication.hideNetworkActivity()
                success(listRejectReason)
            } else {
                UIApplication.hideNetworkActivity()
                failure(response.error!)
            }
        }
    }
    class func getCityList(_ success: @escaping (_ carrer: CarrerList) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let baseUrl = App.baseUrl + "/svccollaborator/api/mstCity"
        let headers = [
            "Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)",
            "Content-Type": "application/json"
        ]
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseCarrerList { response in
            print(response)
            if let carrerList = response.result.value {
                LoadingOverlay.shared.hideOverlayView()
                success(carrerList)
            } else {
                LoadingOverlay.shared.hideOverlayView()
                failure(response.error!)
            }
        }
    }
    class func addRemoveMyJob(_ jobId: Int, status: Int, success: @escaping (_ addRemoveJob: AddRemoveJob) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = collUrl+"/addRemoveMyJob"
        let parameters = [
            "jobId": jobId,
            "status": status
            ] as [String : Any]
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            if let addRemoveJob = try? JSONDecoder().decode(AddRemoveJob.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(addRemoveJob)
            }
        }, failure: { error,response,status in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getMySavedJobs(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (_ myJobSaved: MyJobSaved) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/searchMySaveJobs?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&jobtile=\(jobTitle)&page=\(page)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _,status in
            if let myJobSaved = try? newJSONDecoder().decode(MyJobSaved.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(myJobSaved)
            }
        }, failure: {error,response,status in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getMyAppliedJobs(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (_ myJobApplied: MyJobSaved) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/searchJobsApplyCv?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&jobtile=\(jobTitle)&page=\(page)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _,status in
            if let myJobApplied = try? newJSONDecoder().decode(MyJobSaved.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(myJobApplied)
            }
        }, failure: { error,response,status in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getJobCustomer(cusName:String, page:Int, status:Int, success: @escaping (_ myJobApplied: JobCustomer) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = status != -1 ? customerUrl + "/searchCusHome?itemPerPage=30&jobtile=\(cusName)&page=\(page)&status=\(status)" : customerUrl + "/searchCusHome?itemPerPage=30&jobtile=\(cusName)&page=\(page)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let jobCustomer = try? newJSONDecoder().decode(JobCustomer.self, from: response){
                UIApplication.hideNetworkActivity()
                success(jobCustomer)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func getDetailJobCustomer(jobId:Int, success: @escaping (_ myJobApplied: JobDetailCustomer) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = customerUrl + "/cusjobs/getJobById/\(jobId)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let jobDetailCustomer = try? newJSONDecoder().decode(JobDetailCustomer.self, from: response){
                UIApplication.hideNetworkActivity()
                success(jobDetailCustomer)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
}
