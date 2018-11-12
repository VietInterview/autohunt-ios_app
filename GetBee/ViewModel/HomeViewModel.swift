//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    func loadUserProfile(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        UserAPI.getMyProfile({ user in
            success(user.fullNameColl!)
        }, failure: { error in
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
    
    func saveUnsaveJob(jobId: Int ,status: Int, success: @escaping (AddRemoveJob) -> Void, failure: @escaping (String) -> Void)  {
        JobAPI.addRemoveMyJob( jobId, status: status, success: {addRemoveJob in
            success(addRemoveJob)
        }, failure: {error in
             failure(error.localizedDescription)
        })
    }
    
}
