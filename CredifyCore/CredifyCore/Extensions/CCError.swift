//
//  CCError.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public enum CCError: Error {
    /// Store Data to Realm fails
    case storagePerformFailure
        
    /// Data format is unexpected
    case seriarizeFailure
    
    /// Retrieving secret from Keychain fails, or Storing secret into Keychain fails
    case secretFailure
    
    /// Signing with Private key fails
    case signFailure
    
    /// No account is found in our server by mnemnonic
    case accountNotFound
    
    /// Notifies an error
    case notificationError(message: String)
    
    /// Server Error
    case serverError(message: String)
    
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
            self = err
        }else {
            self = .serverError(message: error.localizedDescription)
        }
    }
}

