//
//  CredifyCore.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 14/03/2021.
//
import CredifyCryptoSwift

public struct CoreService {
    public static var shared: CoreService  = CoreService()
    var environment: CCEnvironment?
    public var encryption: Encryption?
    public var signing: Signing?
    public var password: String?
    
    public var providerUseCase: ProviderUseCaseProtocol
    public var offerUseCase: OfferUseCaseProtocol
    public var claimUseCase: ClaimUseCaseProtocol
    
    var isSDKInitialized: Bool {
        return environment != nil
    }
    
    init() {
        let pr = ProviderRepositoryManager()
        let or = OfferRepositoryManager()
        let km = KeyManagementRepository()
        let cr = ClaimRepositoryManager()
        
        CredifyCoreSDK.shared.validInitialSDK()
        if let config = CredifyCoreSDK.shared.config {
            self.environment = CCEnvironment(config: config)
        }
        self.providerUseCase = ProviderUseCase(repository: pr, kmRepository: km)
        self.offerUseCase = OfferUseCase(repository: or, kmRepository: km)
        self.claimUseCase = ClaimUseCase(repository: cr, kmRepository: km)
    }
}
