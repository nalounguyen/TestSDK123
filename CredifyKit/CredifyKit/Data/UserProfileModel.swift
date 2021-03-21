//
//  UserProfileModel.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


public struct ProfileModel {
    let id: String
    let name: NameModel
    let phone: PhoneModel
    let email: String?
    let dob: String?
    let address: LocationModel?

    var ccModel: CCProfileModel {
        return CCProfileModel(name: name.ccModel,
                              localName: nil,
                              emails: [CCEmailModel("")],
                              phones: [phone.ccModel],
                              dob: CCDOBModel(dob),
                              address: address?.ccModel,
                              nationality: nil,
                              giid: nil)
    }
}

public struct NameModel {
    public let firstName: String?
    public let lastName: String?
    public let middleName: String?
    
    var ccModel: CCNameModel {
        return CCNameModel(firstName: firstName,
                           lastName: lastName,
                           middleName: middleName,
                           verified: false)
    }
}

public struct PhoneModel {
    public let firstName: String?
    public let lastName: String?
    public let middleName: String?
    
    var ccModel: CCPhoneModel {
        return CCPhoneModel(phoneNumber: firstName ?? "",
                            countryCode: lastName ?? "",
                            verified: false)
    }
}

public struct LocationModel {
    public let country: String?
    public let province: String?
    public let city: String?
    public let addressLine: String?
    public let postalCode: String?
    
    var ccModel: CCLocationModel {
        return CCLocationModel(country: country,
                               province: province,
                               city: city,
                               addressLine: addressLine,
                               postalCode: postalCode,
                               verified: nil)
    }
}
