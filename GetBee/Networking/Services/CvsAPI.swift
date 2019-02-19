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
    class func getDetailResumeCustomer(cvId:Int, success: @escaping (_ resumeDetailCustomer: ResumeDetailCustomer) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/getViewCvById/\(cvId)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let resumeDetailCustomer = try? newJSONDecoder().decode(ResumeDetailCustomer.self, from: response){
                UIApplication.hideNetworkActivity()
                success(resumeDetailCustomer)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func getMyCV(carrerId: Int, cityId: Int, page: Int,_ success: @escaping (_ myCv: MyCV) -> Void, failure: @escaping (_ error: Error) -> Void) {
        UIApplication.showNetworkActivity()
        let url = cvsUrl + "/searchMyCv?carrerId=\(carrerId)&itemPerPage=30&cityId=\(cityId)&page=\(page)"
        APIClient.request(.get, url: url, success: { response, _,status in
            if let myCV = try? newJSONDecoder().decode(MyCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(myCV)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func getDetailCV(cvId: Int,_ success: @escaping (_ detailCV: DetailCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/getCvById/\(cvId)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let detailCV = try? newJSONDecoder().decode(DetailCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(detailCV)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func getCVSaved(page: Int,_ success: @escaping (_ detailCV: ListCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/searchCvSave?itemPerPage=30&page=\(page)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let listCV = try? newJSONDecoder().decode(ListCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(listCV)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func getCVUploaded(careerId:Int,fullName:String,page: Int,status:Int,strToDate:String,strfromDate:String,_ success: @escaping (_ detailCV: SaveResumeUpload) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrl + "/searchCvUpload?itemPerPage=30&page=\(page)&careerId=\(careerId)&fullName=\(fullName)&status=\(status)&strToDate=\(strToDate)&strfromDate=\(strfromDate)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let listCV = try? newJSONDecoder().decode(SaveResumeUpload.self, from: response){
                UIApplication.hideNetworkActivity()
                success(listCV)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
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
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let listCVSubmit = try? newJSONDecoder().decode(ListCVSubmit.self, from: response){
                UIApplication.hideNetworkActivity()
                success(listCVSubmit)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func searchMyCV(carrerId: Int, cityId: Int, page: Int,_ success: @escaping (_ detailCV: ListCV) -> Void, failure: @escaping (_ error: Error) -> Void) {
        UIApplication.showNetworkActivity()
        let url = cvsUrl + "/searchMyCv?careerId=\(carrerId)&cityId=\(cityId)&itemPerPage=30&page=\(page)"
        APIClient.request(.get, url: url, success: {response, _,status in
            if let listCV = try? newJSONDecoder().decode(ListCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(listCV)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func deleteCV(cvId: Int,_ success: @escaping (_ deleteCV: DeleteCV) -> Void, failure: @escaping (_ error: Error) -> Void){
        UIApplication.showNetworkActivity()
        let url = cvsUrl + "/delete/\(cvId)"
        APIClient.request(.delete, url: url, success: {response, _,status in
            if let deleteCV = try? newJSONDecoder().decode(DeleteCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(deleteCV)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func deleteCVUpload(cvId: Int,_ success: @escaping (_ status:Int) -> Void, failure: @escaping (_ status: Int) -> Void){
        UIApplication.showNetworkActivity()
        let url = "/svccollaborator/api/cv-uploads/\(cvId)"
        APIClient.request(.delete, url: url, success: {response, _,status in
            UIApplication.hideNetworkActivity()
            success(status)
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(status)
        })
    }
    class func getResumesByJobCustomer(cvName:String, id:Int, page:Int, status:Int,_ success: @escaping (_ resumesByJobCustomer: ResumesByJobCustomer) -> Void, failure: @escaping (_ error: Error) -> Void){
        UIApplication.showNetworkActivity()
        let url = status != 11 ? cvsUrlCus + "searchCusHomeCvByJob?itemPerPage=30&page=\(page)&id=\(id)&cvName=\(cvName)&status=\(status)" : cvsUrlCus + "searchCusHomeCvByJob?itemPerPage=30&page=\(page)&id=\(id)&cvName=\(cvName)"
        APIClient.request(.get, url: url, success: {response, _,status in
            if let resumesByJobCus = try? newJSONDecoder().decode(ResumesByJobCustomer.self, from: response){
                UIApplication.hideNetworkActivity()
                success(resumesByJobCus)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
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
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            if let submitCV = try? newJSONDecoder().decode(SubmitCV.self, from: response){
                UIApplication.hideNetworkActivity()
                success(submitCV)
            }
        }, failure: { errorSubmitCV,response, statusCode  in
            UIApplication.hideNetworkActivity()
            if let error = try? newJSONDecoder().decode(ErrorSubmitCV.self, from: response){
                if error.errorKey == "emailOrPhoneExist" {
                    failure("Ứng viên này đã được chính bạn hoặc CTV viên khác sử dụng và gửi đi. Bạn vui lòng chọn Hồ sơ khác")
                } else if error.errorKey == "cvNotFound" {
                    failure("Hồ sơ không tồn tại")
                } else if error.errorKey == "CvAlreadySubmitJob" {
                    failure("Hồ sơ đã được apply vào job")
                } else {
                    failure(error.message!)
                }
            } else {
                failure(errorSubmitCV.localizedDescription)
            }
        })
    }
    class func detailProcessResume(cvId: Int, jobId: Int,_ success: @escaping (_ detailProcessResume: DetailProcessResume) -> Void, failure: @escaping (_ error: Error) -> Void){
        let url = cvsUrlCus + "cvProcess/detail?cvId=\(cvId)&jobId=\(jobId)"
        UIApplication.showNetworkActivity()
        APIClient.request(.get, url: url, success: {response, _,status in
            if let detailProcessResume = try? newJSONDecoder().decode(DetailProcessResume.self, from: response){
                UIApplication.hideNetworkActivity()
                success(detailProcessResume)
            }
        }, failure: {error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func sendReject(cvId: Int,jobId: Int,reasonNote: String,reasonRejectId: Int, rejectStep: Int, success: @escaping (_ sendReject:SendReject) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/reject"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId,
            "reasonNote": reasonNote,
            "reasonRejectId": reasonRejectId,
            "rejectStep": rejectStep
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let sendReject = try? newJSONDecoder().decode(SendReject.self, from: response){
                success(sendReject)
            }
        }, failure: { error,response ,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func inviteInterview(cvId: Int,jobId: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/inviteInterview"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func offerStatus(cvId: Int,jobId: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/offerStatus"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func gotoworkStatus(cvId: Int,jobId: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/gotoworkStatus"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func contractStatus(cvId: Int,jobId: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/contractStatus"
        let parameters = [
            "cvId": cvId,
            "jobId": jobId
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func sendInviteInterview(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping (SendInterviewResponse) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/sendInterview"
        let parameters = [
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "interviewAddress": interviewAddress,
            "interviewDate": interviewDate,
            "jobId": jobId,
            "note": note,
            "round": round,
            "status": status
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let sendInterviewResponse = try? newJSONDecoder().decode(SendInterviewResponse.self, from: response) {
                success(sendInterviewResponse)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func sendOffer(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping (SendOffer) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/sendOffer"
        let parameters = [
            "curency": curency,
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "jobId": jobId,
            "note": note,
            "position": position,
            "round": round,
            "salary": salary,
            "status": status,
            "workAddress": workAddress,
            "workTime": workTime
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let sendOffer = try? newJSONDecoder().decode(SendOffer.self, from: response) {
                success(sendOffer)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func gotoWorkUpdate(cvId:Int,id:Int,countUpdate:Int, jobId:Int,startWorkDate: String, success: @escaping (GotoWorkUpdate) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/gotoWorkUpdate"
        let parameters = [
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "jobId": jobId,
            "countUpdate": countUpdate,
            "startWorkDate": startWorkDate,
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let gotoWorkUpdate = try? newJSONDecoder().decode(GotoWorkUpdate.self, from: response) {
                success(gotoWorkUpdate)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func updateInterviewStatus(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/updateInterviewStatus"
        let parameters = [
            "cvId": cvId,
            "id": id,
            "interviewAddress": interviewAddress,
            "interviewDate": interviewDate,
            "jobId": jobId,
            "note": note,
            "round": round,
            "status": status
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    
    class func updateOfferStatus(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/updateOfferStatus"
        let parameters = [
            "curency": curency,
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "jobId": jobId,
            "note": note,
            "position": position,
            "round": round,
            "salary": salary,
            "status": status,
            "workAddress": workAddress,
            "workTime": workTime
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            success()
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func viewEmailInterview(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping (SendInterviewResponse) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/viewEmailInterview"
        let parameters = [
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "interviewAddress": interviewAddress,
            "interviewDate": interviewDate,
            "jobId": jobId,
            "note": note,
            "round": round,
            "status": status
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let viewEmailInterview = try? newJSONDecoder().decode(SendInterviewResponse.self, from: response) {
                success(viewEmailInterview)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
    class func viewEmailOffer(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping (SendOffer) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let url = cvsUrlCus + "cvProcess/viewEmailOffer"
        let parameters = [
            "curency": curency,
            "cvId": cvId,
            "id": id == -1 ? nil : id,
            "jobId": jobId,
            "note": note,
            "position": position,
            "round": round,
            "salary": salary,
            "status": status,
            "workAddress": workAddress,
            "workTime": workTime
            ] as [String : Any]
        UIApplication.showNetworkActivity()
        APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
            UIApplication.hideNetworkActivity()
            if let viewEmailOffer = try? newJSONDecoder().decode(SendOffer.self, from: response) {
                success(viewEmailOffer)
            }
        }, failure: { error,response,status in
            UIApplication.hideNetworkActivity()
            failure(error)
        })
    }
}
