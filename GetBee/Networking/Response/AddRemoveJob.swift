///**
/**
Created by: Hiep Nguyen Nghia on 11/8/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   let addRemoveJob = try? newJSONDecoder().decode(AddRemoveJob.self, from: jsonData)

import Foundation

class AddRemoveJob: Codable {
    var collaboratoID, id, jobID, status: Int?
    var updateBy: Int?
    var updateDate: String?
    
    enum CodingKeys: String, CodingKey {
        case collaboratoID = "collaboratoId"
        case id
        case jobID = "jobId"
        case status, updateBy, updateDate
    }
    init(){
        
    }
    init(collaboratoID: Int?, id: Int?, jobID: Int?, status: Int?, updateBy: Int?, updateDate: String?) {
        self.collaboratoID = collaboratoID
        self.id = id
        self.jobID = jobID
        self.status = status
        self.updateBy = updateBy
        self.updateDate = updateDate
    }
}
