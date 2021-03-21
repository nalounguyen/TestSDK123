//
//  CredifyConfiguration.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 18/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


public struct CredifyConfiguration {
    var env: EnvironmentType
    var apiKey: String
    
    
    public init(apiKey: String, environment: EnvironmentType) {
        if apiKey.isEmpty { fatalError("Api key must not be empty") }
        self.apiKey = apiKey
        self.env = environment
    }
}

public class CredifyKitSDK {
    var config: CredifyConfiguration?
    public static let shared = CredifyKitSDK()
    private init() { }
    
    public func config(with config: CredifyConfiguration) {
        self.config = config
        
        
        
        CredifyCoreSDK.shared.config(with: CoreServiceConfiguration(apiKey: config.apiKey,
                                                                    environment: config.env.ccObject))
    }
    
    public var isInitialSDK: Bool {
        return config != nil
    }
    
    func validInitialSDK() {
        if !isInitialSDK {
            fatalError("The SDK is not initialized yet. Using \(CredifyConfiguration.self) for Initial the SDK")
        }

    }
}
