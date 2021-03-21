//
//  CCUserExternalModel.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 19/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public struct CCUserExternalModel {
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
}

