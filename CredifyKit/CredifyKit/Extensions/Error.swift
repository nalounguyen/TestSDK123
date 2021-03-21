//
//  Error.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit
import RxSwift
@_implementationOnly import CredifyCore

extension Error {
    func displayAlert(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let errorDescription = CustomError(error: self).errorDescription
            
            let alert = AlertController(title: "Error".localized(bundle: .CredifyKit, tableName: "Errors"),
                                        message: errorDescription, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK".localized(bundle: .CredifyKit, tableName: "Errors"),
                                       style: .default)
            alert.addAction(action)
            alert.show(completion: completion)
        }
    }
}

enum CustomError: Error {
    /// Store Data to Realm fails
    case storagePerformFailure
        
    /// Data format is unexpected
    case seriarizeFailure
    
    /// Pincode doesn't match
    case pincodeFailure
    
    /// Pincode doesn't match over limit
    case pincodeFailureLimitTimes
    
    /// Wallet generation fails
    case generateWalletFailure
    
    /// Retrieving secret from Keychain fails, or Storing secret into Keychain fails
    case secretFailure
    
    /// Restoring wallet fails
    case restoreFailure
    
    /// Signing with Private key fails
    case signFailure
    
    /// No account is found in our server by mnemnonic
    case accountNotFound
    
    /// Phone number verification failure
    case phoneVerificationFailure
    
    /// Notifies an error
    case notificationError(message: String)
    
    /// Server Error
    case serverError(message: String)
    
    /// LinkedIn Error
    case linkedinConnectFailure
    
    /// Onfido Error
    case onfidoCheckRequestFailure
    
    /// URL Building Error
    case urlBuildingFailure(string: String?)
    
    /// Social Connect Cancel
    case cancelSocialConnect
    
    /// Validation error
    case validationError(message: String)
    
    /// The network is not found
    case noneNetwork
    
    /// Unknown Error
    case unknown
    
    /// The request timed out
    case requestTimeOut
    
    /// Error internal app for checking root cause.
    /// Maybe in the future we need separate it as CustomError for checking internal error
    case internalError(message: String)
    
    init(error: Error) {
        if let err = error as? CCError {
            self.init(core: err)
        }else {
            self = .serverError(message: error.localizedDescription)
        }
    }
    
    init(core: CCError) {
        switch core {
        case .storagePerformFailure:
            self = .storagePerformFailure
            
        case .seriarizeFailure:
            self = .seriarizeFailure
            
        case .secretFailure:
            self = .secretFailure
            
        case .signFailure:
            self = .signFailure
            
        case .accountNotFound:
            self = .accountNotFound
            
        case .notificationError(let message):
            self = .notificationError(message: message)
            
        case .serverError(let message):
            self = .serverError(message: message)
            
        case .validationError(let message):
            self = .validationError(message: message)
            
        case .noneNetwork:
            self = .noneNetwork
            
        case .unknown:
            self = .unknown
            
        case .requestTimeOut:
            self = .requestTimeOut
            
        case .internalError(let message):
            self = .internalError(message: message)
        }
    }
}

private let tn = "Errors"

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .storagePerformFailure:
            return NSLocalizedString("storageFailure".localized(tableName: tn), comment: "Custom Error")
        case .seriarizeFailure:
            return NSLocalizedString("seriarizeFailure".localized(tableName: tn), comment: "Custom Error")
        case .pincodeFailure:
            return NSLocalizedString("pincodeFailure".localized(tableName: tn), comment: "Custom Error")
        case .pincodeFailureLimitTimes:
            return NSLocalizedString("pincodeFailureLimitTimes".localized(tableName: tn), comment: "Custom Error")
        case .generateWalletFailure:
            return NSLocalizedString("generateWalletFailure".localized(tableName: tn), comment: "Custom Error")
        case .secretFailure:
            return NSLocalizedString("secretFailure".localized(tableName: tn), comment: "Custom Error")
        case .restoreFailure:
            return NSLocalizedString("restoreFailure".localized(tableName: tn), comment: "Custom Error")
        case .accountNotFound:
            return NSLocalizedString("accountNotFound".localized(tableName: tn), comment: "Custom Error")
        case .phoneVerificationFailure:
            return NSLocalizedString("phoneVerificationFailure".localized(tableName: tn), comment: "Custom Error")
        case .notificationError(let message):
            return NSLocalizedString(message, comment: "Custom Error")
        case .signFailure:
            return NSLocalizedString("signFailure".localized(tableName: tn), comment: "Custom Error")
        case .unknown:
            return NSLocalizedString("unknown".localized(tableName: tn), comment: "Custom Error")
        case .serverError(let message):
            return NSLocalizedString(message, comment: "Custom Error")
        case .linkedinConnectFailure:
            return NSLocalizedString("linkedinConnectFailure".localized(tableName: tn), comment: "Custom Error")
        case .onfidoCheckRequestFailure:
            return NSLocalizedString("onfidoCheckRequestFailure".localized(tableName: tn), comment: "Custom Error")
        case .urlBuildingFailure(let string):
            return NSLocalizedString(string ?? "None", comment: "Custom Error")
        case .cancelSocialConnect:
            return NSLocalizedString("cancel".localized(tableName: tn), comment: "Custom Error")
        case .noneNetwork:
            return NSLocalizedString("noneNetwork".localized(tableName: tn), comment: "Custom Error")
        case .validationError(let message):
            return NSLocalizedString(message, comment: "Custom Error")
        case .requestTimeOut:
            return NSLocalizedString("requestTimeOut".localized(tableName: tn), comment: "Custom Error")
        case .internalError(let message):
            return NSLocalizedString(message, comment: "Custom Internal Error")
        }
    }
}
