//
//  CCUserThirdPartyModel.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 19/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


public struct UserExternalModel {
    public let id: Int
    public let firName: String
    public let lastName: String
    public let email: String
    public let credifyId: String?
    
    public init(id: Int,
                firName: String,
                lastName: String,
                email: String,
                credifyId: String?) {
        self.id = id
        self.firName = firName
        self.lastName = lastName
        self.email = email
        self.credifyId = credifyId
    }
    
    var ccModel: CCUserExternalModel {
        return CCUserExternalModel(id: id,
                                   firName: firName,
                                   lastName: lastName,
                                   email: email,
                                   credifyId: credifyId)
    }
}
