//
//  ClaimUseCase.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import CredifyCryptoSwift

// This is internal class.
class ClaimUseCase: ClaimUseCaseProtocol {
    private let repository: ClaimRepositoryProtocol
    private let kmRepository: KeyManagementRepositoryProtocol
    private let bag = DisposeBag()
    
    private let getEncryptedClaimEventSubject = PublishSubject<[CCScopeModel]>()
    private let getCustomScopeEventSubject = PublishSubject<[CCScopeModel]>()
    private let errorEventSubject = PublishSubject<CCError>()
    
    
    init(repository: ClaimRepositoryProtocol,
         kmRepository: KeyManagementRepositoryProtocol) {
        self.repository = repository
        self.kmRepository = kmRepository
    }
    
    lazy var getEncryptedClaimEvent: Observable<[CCScopeModel]> = {
        return getEncryptedClaimEventSubject.asObserver()
    }()
    
    lazy var getCustomScopeEvent: Observable<[CCScopeModel]> = {
        return getCustomScopeEventSubject.asObservable()
    }()
    
    lazy var errorEvent: Observable<CCError> = {
        return errorEventSubject.asObserver()
    }()
    
    
    
    func getEncryptedClaim() {
        var encryptionKey: Encryption? = CoreService.shared.encryption
        kmRepository
            .getEncryptionKey()
            .asObservable()
            .flatMap { encryption -> Observable<GetEncryptedClaimRestResponse> in
                encryptionKey = encryption
                return self.repository.getEncryptedClaim()
            }.subscribe(onNext: { res in
                guard let encryptionKey = encryptionKey else {
                    self.errorEventSubject.onNext(CCError.internalError(message: "Get Encrypted Claim Fail !!!"))
                    return
                }
                
                if res.success {
                    // Decryption claims
                    var claimList = [CCClaimModel]()
                    let scopeDict = res.data["claims"]
                    scopeDict?.forEach({ scope in
                        let claimDict = try? self.decrypted(ciphertext: scope.value, encryption: encryptionKey).convertToMetadataDictionary()
                        claimDict?.forEach({ claim in
                            print(claim.key)
                            print(claim.value)
                            let model = CCClaimModel.init(scopeName: scope.key,
                                                        claimName: claim.key,
                                                        claimValue: claim.value.toString(),
                                                        claimValueType: claim.value,
                                                        displayName: nil)
                            claimList.append(model)
                        })
                    })
                    
                    // Group claims to scopes by `scopeName`
                    let result = CCScopeModel.converToScopes(with: claimList)
                    self.getEncryptedClaimEventSubject.onNext(result)
                }else {
                    self.errorEventSubject .onNext(CCError.unknown)
                    
                }
                
            }, onError: { err in
                self.errorEventSubject.onNext(CCError(error: err))
            }).disposed(by: bag)
    }
    
    func getAttachedCustomClaims(providerId: String?) {
        repository
            .getAttachedCustomClaims(providerId: providerId)
            .subscribe(onNext: { res in
                if res.success {
                    var providerRestResponse = [ProviderRestResponse]()
                    var allScopeRestResponse = [ScopeRestResponse]()
                    // Filter provider by providerId
                    if let id = providerId {
                        providerRestResponse = res.data.providers.filter {  $0.id == id }
                    }
                    
                    for provider in providerRestResponse {
                        for scopeRest in provider.scopes {
                            if res.data.claims.contains(where: { $0.scope_name == scopeRest.name }) {
                                allScopeRestResponse.append(scopeRest)
                            }
                        }
                    }
                    
                    let customScopes = allScopeRestResponse.map { item -> CCScopeModel in
                        let claims = item.claims.map { claimRest  -> CCClaimModel in
                            let claimModel = CCClaimModel(scopeName: item.name ?? "",
                                                          claimName: claimRest.name ?? "",
                                                          claimValue: "",
                                                          claimValueType: .string(""),
                                                          displayName: claimRest.displayName)
                            return claimModel
                        }
                        return CCScopeModel(name: item.name ?? "",
                                            displayName: item.displayName,
                                            claims: claims)
                    }
                    
                    
                    self.getCustomScopeEventSubject.onNext(customScopes)
                }else {
                    self.errorEventSubject.onNext(CCError.unknown)
                }
            }, onError: { err in
                self.errorEventSubject.onNext(CCError(error: err))
            })
            .disposed(by: bag)
    }
    
    
    
    
    
    
    private func decrypted(ciphertext: String, encryption: Encryption) throws -> String {
        if !ciphertext.isEmpty {
            return try encryption.decrypt(base64UrlCipher: ciphertext)
        }
        return ciphertext
    }
}
