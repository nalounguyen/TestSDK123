//
//  CoreServiceConfiguration.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public struct CoreServiceConfiguration {
    public let env: CCEnvironmentType
    public let apiKey: String
    
    
    public init(apiKey: String, environment: CCEnvironmentType) {
        if apiKey.isEmpty { fatalError("Api key must not be empty") }
        self.apiKey = apiKey
        self.env = environment
    }
}

public class CredifyCoreSDK {
    var config: CoreServiceConfiguration?
    public static let shared = CredifyCoreSDK()
    private init() { }
    
    public func config(with config: CoreServiceConfiguration) {
        self.config = config
    }
    
    public var isInitialSDK: Bool {
        return config != nil
    }
    
    func validInitialSDK() {
        if !isInitialSDK {
            fatalError("The SDK is not initialized yet. Please Initial the SDK")
        }

    }
}
