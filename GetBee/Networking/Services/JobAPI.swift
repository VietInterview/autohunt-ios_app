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
        let url = collUrl + "/searchJob?carrerId=\(carrerId)&jobtile=\(jobTitle)&itemPerPage=30&cityId=\(cityId)&page=\(page)"
        APIClient.request(.get, url: url, success: { response, _ in
            do {
                let job = try? JSONDecoder().decode(Job.self, from: response)
                success(job!)
            } catch {
                failure(App.error(domain: .parsing, localizedDescription: "Could not parse a valid user".localized))
            }
        }, failure: { error in
            failure(error)
        })
    }
    class func getDetailJob(jobId: Int,_ success: @escaping (_ detailJob: JobDetail) -> Void, failure: @escaping (_ error: Error) -> Void){
        //         let baseUrl = App.baseUrl + "/svccollaborator/api/jobs/getJobDetail?"
        //        let headers = [
        //            "Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)",
        //            "Content-Type": "application/json"
        //        ]
        //           Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJobDetail { response in
        //             if let jobDetail = response.result.value {
        //               print(jobDetail)
        //             }
        //           }
        let url = collUrl + "/getJobDetail?jobId=\(jobId)"
        APIClient.request(.get, url: url, success: {response, _ in
            do {
                let detailJob = try? JSONDecoder().decode(JobDetail.self, from: response)
                success(detailJob!)
            } catch {
                failure(App.error(domain: .parsing, localizedDescription: "Could not parse a valid user".localized))
            }
        }, failure: {error in
            failure(error)
        })
    }
    class func getCarrerList(_ success: @escaping (_ carrer: CarrerList) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let baseUrl = App.baseUrl + "/svccollaborator/api/mstCareer"
        let headers = [
            "Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)",
            "Content-Type": "application/json"
        ]
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseCarrerList { response in
            print(response)
            if let carrerList = response.result.value {
                success(carrerList)
            } else {
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
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseCarrerList { response in
            print(response)
            if let carrerList = response.result.value {
                success(carrerList)
            } else {
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
        APIClient.request(.post, url: url, params: parameters, success: { response, headers in
            let addRemoveJob = try? JSONDecoder().decode(AddRemoveJob.self, from: response)
            success(addRemoveJob!)
        }, failure: { error in
            failure(error)
        })
    }
}
