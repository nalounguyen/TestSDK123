////
////  CCAccountModel.swift
////  Credify
////
////  Created by Nalou Nguyen on 05/03/2021.
////  Copyright © 2021 Credify. All rights reserved.
////
//
//import Foundation
//
//
///// Identity data object
//public struct CCIdentityModel: Codable {
//    /// Identity category (e.g. DID, KYC, Oauth)
//    public let category: CCIdentityCategory
//    /// Identity source (e.g. Credify, Facebook, LinkedIn, Onfido, Bloom, etc.)
//    public let source: CCIdentitySource
//    /// Profile information. This depends on each platform, like Some are using different names on each platform.
//    public let profile: CCAccountProfile
//    
//    private enum CodingKeys: String, CodingKey {
//        case category
//        case source
//        case profile
//    }
//    
//    public init(_ res: CCIdentityResponse) {
//        self.category = res.category
//        self.source = res.source
//        self.profile = res.profile
//    }
//    
//    public init(category: CCIdentityCategory, source: CCIdentitySource, profile: CCAccountProfile) {
//        self.category = category
//        self.source = source
//        self.profile = profile
//    }
//    
//    public func decrypt(by hdwallet: HDWalletWallet) -> CCIdentityModel {
//        var decryptedName: CCName? = nil
//        if let n = profile.name {
//            let fn = hdwallet.decryptBase64(n.firstName)
//            let ln = hdwallet.decryptBase64(n.lastName)
//            var mn: String? = nil
//            if let middleName = n.middleName {
//                mn = hdwallet.decryptBase64(middleName)
//            }
//            
//            decryptedName = CCName(firstName: fn, lastName: ln, middleName: mn)
//        }
//        var decryptedLocalName: CCName? = nil
//        if let n = profile.localName {
////            var lfn: String? = nil
////            if let firstName = n.firstName {
////                lfn = hdwallet.decryptBase64(firstName)
////            }
//            let lfn = hdwallet.decryptBase64(n.firstName)
//            
////            var lmn: String? = nil
////            if let middleName = n.middleName {
////                lmn = hdwallet.decryptBase64(middleName)
////            }
//            let lmn = hdwallet.decryptBase64(n.middleName)
////            var lln: String? = nil
////            if let lastName = n.lastName {
////                lln = hdwallet.decryptBase64(lastName)
////            }
//            let lln = hdwallet.decryptBase64(n.lastName)
//            
//            decryptedLocalName = CCName(firstName: lfn, lastName: lln, middleName: lmn)
//        }
//        var decryptedEmail: String? = nil
//        if let e = profile.emailAddress {
//            decryptedEmail = hdwallet.decryptBase64(e)
//        }
//        var decryptedDob: String? = nil
//        if let d = profile.dob {
//            decryptedDob = hdwallet.decryptBase64(d)
//        }
//        var decryptedPhone: CCPhone? = nil
//        if let p = profile.phone {
//            let pn = hdwallet.decryptBase64(p.phoneNumber)
//            let cc = hdwallet.decryptBase64(p.countryCode)
//            decryptedPhone = CCPhone(phoneNumber: pn, countryCode: cc)
//        }
//        var decryptedLocation: CCLocation? = nil
//        if let l = profile.address {
//            var decryptedCountry: String? = nil
//            if let c = l.country {
//                decryptedCountry = hdwallet.decryptBase64(c)
//            }
//            var decryptedProvince: String? = nil
//            if let p = l.province {
//                decryptedProvince = hdwallet.decryptBase64(p)
//            }
//            var decryptedCity: String? = nil
//            if let c = l.city {
//                decryptedCity = hdwallet.decryptBase64(c)
//            }
//            var decryptedAddress: String? = nil
//            if let a = l.addressLine {
//                decryptedAddress = hdwallet.decryptBase64(a)
//            }
//            var decryptedZipCode: String? = nil
//            if let z = l.postalCode {
//                decryptedZipCode = hdwallet.decryptBase64(z)
//            }
//            decryptedLocation = CCLocation(country: decryptedCountry, province: decryptedProvince, city: decryptedCity, addressLine: decryptedAddress, postalCode: decryptedZipCode)
//        }
//        var decryptedNationality: String? = nil
//        if let n = profile.nationality {
//            decryptedNationality = hdwallet.decryptBase64(n)
//        }
//        
//        let newProfile = CCAccountProfile(name: decryptedName, localName: decryptedLocalName, email: decryptedEmail, phone: decryptedPhone, dob: decryptedDob, address: decryptedLocation, nationality: decryptedNationality)
//        return CCIdentityModel(category: self.category, source: self.source, profile: newProfile)
//    }
//}
//
//public struct CCAccountModel: Codable {
//    public let id: String
//    public let externalProviders: [CCExternalProvider]
//    public let limiter: Int
//    public let recoveryCode: String?
//    public let invitationCode: String
//    public let identities: [CCIdentityModel]
//    public let attachingIdentities: [CCIdentityModel]
//    public let pendingIdentities: [CCIdentityModel]
//    
//    public init(_ res: AccountResponse?) throws {
//        guard let res = res else { throw CCError.seriarizeFailure }
//        self.id = res.id
//        self.externalProviders = res.externalProviders ?? []
//        self.limiter = res.limiter ?? 0
//        self.recoveryCode = res.recoveryCode
//        self.invitationCode = res.invitationCode
//        if let identities = res.identities {
//            self.identities = identities.map { CCIdentityModel($0) }
//        } else {
//            self.identities = []
//        }
//        if let attachingIdentities = res.attachingIdentities {
//            self.attachingIdentities = attachingIdentities.map { CCIdentityModel($0) }
//        } else {
//            self.attachingIdentities = []
//        }
//        if let pendingIdentities = res.pendingIdentities {
//            self.pendingIdentities = pendingIdentities.map { CCIdentityModel($0) }
//        } else {
//            self.pendingIdentities = []
//        }
//    }
//    
//    public init(_ res: AccountResponse) {
//        self.id = res.id
//        self.externalProviders = res.externalProviders ?? []
//        self.limiter = res.limiter ?? 0
//        self.recoveryCode = res.recoveryCode
//        self.invitationCode = res.invitationCode
//        if let identities = res.identities {
//            self.identities = identities.map { CCIdentityModel($0) }
//        } else {
//            self.identities = []
//        }
//        if let attachingIdentities = res.attachingIdentities {
//            self.attachingIdentities = attachingIdentities.map { CCIdentityModel($0) }
//        } else {
//            self.attachingIdentities = []
//        }
//        if let pendingIdentities = res.pendingIdentities {
//            self.pendingIdentities = pendingIdentities.map { CCIdentityModel($0) }
//        } else {
//            self.pendingIdentities = []
//        }
//    }
//    
//    public init(id: String, ep: [CCExternalProvider], lm: Int, rc: String?, ic: String, ids: [CCIdentityModel], attachingIds: [CCIdentityModel], pendingIds: [CCIdentityModel]) {
//        self.id = id
//        self.externalProviders = ep
//        self.limiter = lm
//        self.recoveryCode = rc
//        self.invitationCode = ic
//        self.identities = ids
//        self.attachingIdentities = attachingIds
//        self.pendingIdentities = pendingIds
//    }
//    
//    /// Credify identity; stored in IPFS/EOS
//    public var credify: CCIdentityModel? {
//        return identities.filter { $0.source == .credify }.last
//    }
//    
//    /// Credify identity; confirmed but not stored in IPFS/EOS
//    public var attachingCredify: CCIdentityModel? {
//        return attachingIdentities.filter { $0.source == .credify }.last
//    }
//    
//    /// Credify identity; combined with complete/confirmed/non-confirmed data, Last edited data is to be set
//    public var mergedCredify: CCIdentityModel? {
//        var name: CCName? = nil
//        var localName: CCName? = nil
//        var dob: String? = nil
//        var email: String? = nil
//        var phone: CCPhone? = nil
//        var location: CCLocation? = nil
//        var nationality: String? = nil
//        let pendingArr: [CCIdentityModel] = pendingIdentities.filter { $0.source == .credify }.reversed()
//        let attachingArr: [CCIdentityModel] = attachingIdentities.filter { $0.source == .credify }.reversed()
//        var arr: [CCIdentityModel] = pendingArr + attachingArr
//        if let c = credify { arr.append(c) }
//        arr.forEach { model in
//            if let n = model.profile.name, name == nil {
//                name = n
//            }
//            if let n = model.profile.localName, localName == nil {
//                localName = n
//            }
//            if let d = model.profile.dob, dob == nil || dob == "" {
//                dob = d
//            }
//            if let e = model.profile.emailAddress, email == nil || email == "" {
//                email = e
//            }
//            if let p = model.profile.phone, phone == nil {
//                phone = p
//            }
//            if let l = model.profile.address, location == nil {
//                location = l
//            }
//            if let n = model.profile.nationality, nationality == nil {
//                nationality = n
//            }
//        }
//        let profile = CCAccountProfile(name: name, localName: localName, email: email, phone: phone, dob: dob, address: location, nationality: nationality)
//        return CCIdentityModel(category: .did, source: .credify, profile: profile)
//    }
//
//    /// Credify identity; combined with complete/confirmed/non-confirmed data, Last edited data is to be set
//    public var trustedProfile: CCOIDCProfile? {
//        if let completedProfile = credify?.profile {
//            return CCOIDCProfile(name: completedProfile.primaryName, dob: completedProfile.dob)
//        }
//        if let attachingProfile = attachingCredify?.profile {
//            return CCOIDCProfile(name: attachingProfile.primaryName, dob: attachingProfile.dob)
//        }
//        return nil
//    }
//
//    public var trustedLocation: CCLocation? {
//        if let completedProfile = credify?.profile {
//            return completedProfile.address
//        }
//        if let attachingProfile = attachingCredify?.profile {
//            return attachingProfile.address
//        }
//        return nil
//    }
//    
//    public var facebook: (model: CCIdentityModel?, status: CCConfirmationStatus) {
//        let completed = identities.filter { $0.source == .facebook }.last
//        if completed != nil {
//            return (model: completed, status: .completed)
//        }
//        let attaching = attachingIdentities.filter { $0.source == .facebook }.last
//        if attaching != nil {
//            return (model: attaching, status: .confirmed)
//        }
//        return (model: nil, status: .notConfirmed)
//    }
//    
//    public var linkedin: (model: CCIdentityModel?, status: CCConfirmationStatus) {
//        let completed = identities.filter { $0.source == .linkedin }.last
//        if completed != nil {
//            return (model: completed, status: .completed)
//        }
//        let attaching = attachingIdentities.filter { $0.source == .linkedin }.last
//        if attaching != nil {
//            return (model: attaching, status: .confirmed)
//        }
//        return (model: nil, status: .notConfirmed)
//    }
//    
//    public var line: (model: CCIdentityModel?, status: CCConfirmationStatus) {
//        let completed = identities.filter { $0.source == .line }.last
//        if completed != nil {
//            return (model: completed, status: .completed)
//        }
//        let attaching = attachingIdentities.filter { $0.source == .line }.last
//        if attaching != nil {
//            return (model: attaching, status: .confirmed)
//        }
//        return (model: nil, status: .notConfirmed)
//    }
//    
//    public var onfido: (model: CCIdentityModel?, status: CCConfirmationStatus) {
//        let completed = identities.filter { $0.category == .kyc }.last
//        if completed != nil {
//            return (model: completed, status: .completed)
//        }
//        let attaching = attachingIdentities.filter { $0.category == .kyc }.last
//        if attaching != nil {
//            return (model: attaching, status: .confirmed)
//        }
//        return (model: nil, status: .notConfirmed)
//    }
//    
//    public var pendingEmailAddress: String? {
//        let pendingCredify = pendingIdentities.filter { $0.source == .credify }
//        if let pending = pendingCredify.first {
//            return pending.profile.emailAddress
//        }
//        return nil
//    }
//    
//    public var pendingPhone: CCPhone? {
//        if let pending = pendingIdentities.first {
//            return pending.profile.phone
//        }
//        return nil
//    }
//    
//    public var trustedEmail: (emailAddress: String?, status: CCConfirmationStatus) {
//        if let e = credify?.profile.emailAddress, !e.isEmpty {
//            return (emailAddress: e, status: .completed)
//        }
//        if let e = attachingCredify?.profile.emailAddress, !e.isEmpty {
//            return (emailAddress: e, status: .confirmed)
//        }
//        return (emailAddress: pendingEmailAddress, status: .notConfirmed)
//    }
//    
//    public var trustedPhone: (phone: CCPhone?, status: CCConfirmationStatus) {
//        if let p = credify?.profile.phone {
//            return (phone: p, status: .completed)
//        }
//        if let p = attachingCredify?.profile.phone {
//            return (phone: p, status: .confirmed)
//        }
//        return (phone: pendingPhone, status: .notConfirmed)
//    }
//    
//    public var isKycEnabled: Bool {
//        if !isKycAvailable { return false }
//        return kycStatus == .notConfirmed
//    }
//    
//    public var isKycAvailable: Bool {
//        if emailStatus != .completed {
//            return false
//        }
//        return true
//    }
//    
//    /// KYC processing status. E-KYC provider (Onfido) is checking KYC docs.
//    public var isKycProcessing: Bool {
//        // dirty hack. We shouldn't access to UserDefault from this layer.
//        return KYCRepository().isKYCProcessing
//    }
//    
//    public var kycStatus: CCConfirmationStatus {
//        return onfido.status
//    }
//    
//    public var credifyStatus: CCConfirmationStatus {
//        if attachingCredify != nil && emailStatus != .confirmed && phoneStatus != .confirmed {
//            return .confirmed
//        }
//        if credify != nil { return .completed }
//        return .notConfirmed
//    }
//    
//    public var emailStatus: CCConfirmationStatus {
//        if let pe = pendingEmailAddress, pe.count > 0 { return .notConfirmed }
//        let attachingCredify = attachingIdentities.filter { $0.source == .credify }.first
//        if let e = attachingCredify?.profile.emailAddress, e != "" {
//            return .confirmed
//        }
//        return .completed
//    }
//    
//    public var phoneStatus: CCConfirmationStatus {
//        if pendingPhone != nil { return .notConfirmed }
//        let attachingCredify = attachingIdentities.filter { $0.source == .credify }.first
//        if attachingCredify?.profile.phone != nil {
//            return .confirmed
//        }
//        return .completed
//    }
//    
//    public func decrypt(by hdwallet: HDWalletWallet) -> CCAccountModel {
//        return CCAccountModel(
//            id: self.id,
//            ep: self.externalProviders.map { $0.decrypt(by: hdwallet) },
//            lm: self.limiter,
//            rc: self.recoveryCode,
//            ic: self.invitationCode,
//            ids: identities.map { $0.decrypt(by: hdwallet) },
//            attachingIds: attachingIdentities.map { $0.decrypt(by: hdwallet) },
//            pendingIds: pendingIdentities.map { $0.decrypt(by: hdwallet) }
//        )
//    }
//    
//    public func executingItems() -> [CCHistory] {
//        var executingItems: [CCHistory] = []
//        if let _ = attachingCredify {
//            let item = CCHistory(id: id, type: .attachingIdentity, createdAt: Date().toISO(), detail: CCHistoryDetail(identityType: .credify, changes: nil, asset: nil, from: nil, to: nil, client: nil, offer: nil, approval: nil))
//            executingItems.append(item)
//        }
//        if facebook.status == .confirmed {
//            let item = CCHistory(id: id, type: .attachingIdentity, createdAt: Date().toISO(), detail: CCHistoryDetail(identityType: .facebook, changes: nil, asset: nil, from: nil, to: nil, client: nil, offer: nil, approval: nil))
//            executingItems.append(item)
//        }
//        if linkedin.status == .confirmed {
//            let item = CCHistory(id: id, type: .attachingIdentity, createdAt: Date().toISO(), detail: CCHistoryDetail(identityType: .linkedin, changes: nil, asset: nil, from: nil, to: nil, client: nil, offer: nil, approval: nil))
//            executingItems.append(item)
//        }
//        if onfido.status == .confirmed {
//            // TODO: This identity type needs to be dynamic. Storing .voterID for a temporary purpose
//            let item = CCHistory(id: id, type: .attachingIdentity, createdAt: Date().toISO(), detail: CCHistoryDetail(identityType: .voterID, changes: nil, asset: nil, from: nil, to: nil, client: nil, offer: nil, approval: nil))
//            executingItems.append(item)
//        }
//        return executingItems
//    }
//}
