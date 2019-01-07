//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    func loadUserProfile(success: @escaping (GetMyProfile) -> Void, failure: @escaping (String) -> Void) {
        UserAPI.getMyProfile({ user in
            success(user)
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func loadCustomerProfile(success: @escaping (ProfileCustomer) -> Void, failure: @escaping (String) -> Void) {
        UserAPI.getCusProfile({ user in
            success(user)
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func loadAccount(success: @escaping (Account) -> Void, failure: @escaping (String) -> Void){
        UserAPI.getAccount({account in
            success(account)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func saveMyProfile(fullName:String, phone: String, address: String, carrer: String, arrCaerrerhunt: [DesideratedCareer],success: @escaping (GetMyProfile) -> Void, failure: @escaping (String) -> Void){
        UserAPI.saveMyProfile(fullName: fullName, phone: phone, address: address, carrer: carrer, arrCarrerHunt: arrCaerrerhunt, {user in
            success(user)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getSearchJob(carrerId: Int, cityId: Int, jobTitle: String, page: Int,success: @escaping (Job) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getSearchJob(carrerId: carrerId,jobTitle: jobTitle, cityId: cityId, page: page,{ job in
            success(job)
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func getJobCustomer(cusName:String, page:Int, status:Int,success: @escaping (JobCustomer) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getJobCustomer(cusName: cusName, page: page, status: status, success: {jobCustomer in
            success(jobCustomer)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getDetailJob(jobId: Int, success: @escaping (JobDetail) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getDetailJob(jobId: jobId, {jobDetail in
            success(jobDetail)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getCarrer(success: @escaping (CarrerList) -> Void, failure: @escaping (String) -> Void) {
        JobAPI.getCarrerList({carrers in
            success(carrers)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getListReasonReject(success: @escaping (ListRejectReason) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getListRejectReason({listRejectReason in
            success(listRejectReason)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getCity(success: @escaping (CarrerList) -> Void, failure: @escaping (String) -> Void) {
        JobAPI.getCityList({citys in
            success(citys)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func logoutUser(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        UserAPI.logout(success, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func getMyCVSubmit(carrerId: Int, cityId: Int, page: Int, success: @escaping (MyCV) -> Void, failure: @escaping (String) -> Void) {
        CvsAPI.getMyCV(carrerId: carrerId, cityId: cityId, page: page, { myCv in
            success(myCv)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func saveUnsaveJob(jobId: Int ,status: Int, success: @escaping (AddRemoveJob) -> Void, failure: @escaping (String) -> Void)  {
        JobAPI.addRemoveMyJob( jobId, status: status, success: {addRemoveJob in
            success(addRemoveJob)
        }, failure: {error in
             failure(error.localizedDescription)
        })
    }
    func getDetailCV(cvId: Int, success: @escaping (DetailCV) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.getDetailCV(cvId: cvId, {detailCV in
            success(detailCV)
        }, failure: {error in
              failure(error.localizedDescription)
        })
    }
    func getListCVSaved(page: Int,success: @escaping (ListCV) -> Void, failure: @escaping (String) -> Void) {
        CvsAPI.getCVSaved(page: page, {listCV in
            success(listCV)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getListCVSubmit(carrerId: Int, cityId: Int, statusId: Int, page: Int,success: @escaping (ListCVSubmit) -> Void, failure: @escaping (String) -> Void) {
        CvsAPI.getCVSubmit(carrerID: carrerId, cityId: cityId, statusId: statusId, page: page, {listCVSubmit in
            success(listCVSubmit)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func searchMyCV(carrerId: Int, cityId: Int, page: Int,success: @escaping (ListCV) -> Void, failure: @escaping (String) -> Void) {
        CvsAPI.searchMyCV(carrerId: carrerId, cityId: cityId, page: page, {listCV in
            success(listCV)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getResumesByJobCus(CvName:String, id:Int, page:Int, status:Int,success: @escaping (ResumesByJobCustomer) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.getResumesByJobCustomer(cvName: CvName, id: id, page: page, status: status, {resumesByJobCustomer in
            success(resumesByJobCustomer)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func deleteCV(cvId: Int,success: @escaping (DeleteCV) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.deleteCV(cvId: cvId, {deleteCV in
            success(deleteCV)
        }, failure: {error in
             failure(error.localizedDescription)
        })
    }
    func searchMySavedJob(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (MyJobSaved) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getMySavedJobs(carrerId: carrerId, cityId: cityId, jobTitle: jobTitle, page: page, success: { myJobSaved in
            success(myJobSaved)
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func searchMyAppliedJob(carrerId: Int, cityId: Int, jobTitle: String, page: Int, success: @escaping (MyJobSaved) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getMyAppliedJobs(carrerId: carrerId, cityId: cityId, jobTitle: jobTitle, page: page, success: { myJobApplied in
            success(myJobApplied)
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    func submitCV(cvId: Int, jobId: Int, type: Int, success: @escaping (SubmitCV) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.submitCV( cvId: cvId, jobId: jobId,  type: type, { submitCV in
            success(submitCV)
        }, failure: {error in
            failure(error)
        })
    }
    func changePassword(currentPass: String, newPass: String,success: @escaping () -> Void, failure: @escaping (String, Int) -> Void){
        UserAPI.changePassword(currentPassword: currentPass, newPassword: newPass, success: success, failure: {error, statusCode  in
            failure(error, statusCode)
        })
    }
    func getJobDetailCustomer(jobId:Int, success: @escaping (JobDetailCustomer) -> Void, failure: @escaping (String) -> Void){
        JobAPI.getDetailJobCustomer(jobId: jobId, success: {jobDetailCustomer in
            success(jobDetailCustomer)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getDetailResumeCustomer(cvId:Int, success: @escaping (ResumeDetailCustomer) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.getDetailResumeCustomer(cvId: cvId, success: {resumeDetailCustomer in
            success(resumeDetailCustomer)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func getDetailProcessResume(cvId:Int, jobId: Int, success: @escaping (DetailProcessResume) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.detailProcessResume(cvId: cvId, jobId: jobId, {detailProcessResume in
            success(detailProcessResume)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func sendReject(cvId: Int,jobId: Int,reasonNote: String,reasonRejectId: Int, rejectStep: Int, success: @escaping (SendReject) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.sendReject(cvId: cvId, jobId: jobId, reasonNote: reasonNote, reasonRejectId: reasonRejectId, rejectStep: rejectStep, success: {sendReject in
            success(sendReject)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func inviteInterview(cvId:Int, jobId:Int, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.inviteInterview(cvId: cvId, jobId: jobId, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func gotoworkStatus(cvId:Int, jobId:Int, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.gotoworkStatus(cvId: cvId, jobId: jobId, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func contractStatus(cvId:Int, jobId:Int, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.contractStatus(cvId: cvId, jobId: jobId, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func sendInviteInterview(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping (SendInterviewResponse) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.sendInviteInterview(cvId: cvId, id: id, interviewAddress: interviewAddress, interviewDate: interviewDate, jobId: jobId, note: note, round: round, status: status, success: {sendInterviewResponse in
            success(sendInterviewResponse)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func updateInterviewStatus(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.updateInterviewStatus(cvId: cvId, id: id, interviewAddress: interviewAddress, interviewDate: interviewDate, jobId: jobId, note: note, round: round, status: status, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func gotoWorkUpdate(cvId:Int, id:Int, countUpdate:Int, jobId:Int, startWorkDate:String,success: @escaping (GotoWorkUpdate) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.gotoWorkUpdate(cvId: cvId, id: id, countUpdate: countUpdate, jobId: jobId, startWorkDate: startWorkDate, success: {gotoWorkUpdate in
            success(gotoWorkUpdate)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func viewEmailInterview(cvId: Int,id:Int,interviewAddress:String,interviewDate:String,jobId: Int,note:String,round:String,status:Int, success: @escaping (SendInterviewResponse) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.viewEmailInterview(cvId: cvId, id: id, interviewAddress: interviewAddress, interviewDate: interviewDate, jobId: jobId, note: note, round: round, status: status, success: {viewEmailInterview in
            success(viewEmailInterview)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
    
    func offerStatus(cvId:Int, jobId:Int, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.offerStatus(cvId: cvId, jobId: jobId, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func sendOffer(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping (SendOffer) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.sendOffer(curency: curency, cvId: cvId, id: id, jobId: jobId, note: note, position: position, round: round, salary: salary, status: status, workAddress: workAddress, workTime: workTime, success: {sendOffer in
            success(sendOffer)
        }, failure: {error in
             failure(error.localizedDescription)
        })
    }
    func updateOfferStatus(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping () -> Void, failure: @escaping (String) -> Void){
        CvsAPI.updateOfferStatus(curency: curency, cvId: cvId, id: id, jobId: jobId, note: note, position: position, round: round, salary: salary, status: status, workAddress: workAddress, workTime: workTime, success: {success()}, failure: {error in
            failure(error.localizedDescription)
        })
    }
    func viewEmailOffer(curency: Int,cvId:Int,id:Int,jobId:Int,note: String,position:String,round:String,salary:Int,status:Int,workAddress:String,workTime:String, success: @escaping (SendOffer) -> Void, failure: @escaping (String) -> Void){
        CvsAPI.viewEmailOffer(curency: curency, cvId: cvId, id: id, jobId: jobId, note: note, position: position, round: round, salary: salary, status: status, workAddress: workAddress, workTime: workTime, success: {viewEmail in
            success(viewEmail)
        }, failure: {error in
            failure(error.localizedDescription)
        })
    }
}
