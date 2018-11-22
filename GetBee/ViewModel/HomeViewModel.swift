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
}
