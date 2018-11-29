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
    class func getSearchJob(carrerId: Int, jobTitle: String, cityId: Int, page: Int,_ success: @escaping (_ job: Job) -> Void, failure: @escaping (_ error: Error) -> Void) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let url = collUrl + "/searchJob?careerId=\(carrerId)&jobtile=\(jobTitle)&itemPerPage=30&cityId=\(cityId)&page=\(page)"
        APIClient.request(.get, url: url, success: { response, _ in
            LoadingOverlay.shared.hideOverlayView()
            if let job = try? JSONDecoder().decode(Job.self, from: response){
                success(job)
            }
        }, failure: { error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getDetailJob(jobId: Int,_ success: @escaping (_ detailJob: JobDetail) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/getJobDetail?jobId=\(jobId)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let detailJob = try? JSONDecoder().decode(JobDetail.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(detailJob)
            }
        }, failure: {error in
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
        APIClient.request(.post, url: url, params: parameters, success: { response, headers in
            if let addRemoveJob = try? JSONDecoder().decode(AddRemoveJob.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(addRemoveJob)
            }
        }, failure: { error in
             LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getMySavedJobs(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (_ myJobSaved: MyJobSaved) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/searchMySaveJobs?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&jobtile=\(jobTitle)&page=\(page)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let myJobSaved = try? newJSONDecoder().decode(MyJobSaved.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(myJobSaved)
            }
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
    class func getMyAppliedJobs(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (_ myJobApplied: MyJobSaved) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = collUrl + "/searchJobsApplyCv?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&jobtile=\(jobTitle)&page=\(page)"
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        APIClient.request(.get, url: url, success: {response, _ in
            if let myJobApplied = try? newJSONDecoder().decode(MyJobSaved.self, from: response){
                LoadingOverlay.shared.hideOverlayView()
                success(myJobApplied)
            }
        }, failure: { error in
            LoadingOverlay.shared.hideOverlayView()
            failure(error)
        })
    }
}
