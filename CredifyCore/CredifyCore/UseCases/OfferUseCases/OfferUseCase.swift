//
//  OfferUseCase.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift

// This is internal class.
class OfferUseCase: OfferUseCaseProtocol {
    private let repository: OfferRepositoryProtocol
    private let kmRepository: KeyManagementRepositoryProtocol
    private let bag = DisposeBag()
    
    let offerRedeemEventSubject = PublishSubject<CCOfferRedeem>()
    let offerEvaluationEventSubject = PublishSubject<Int>()
    let requiredScopeEventSubject = PublishSubject<[CCScopeData]>()
    let errorEventSubject = PublishSubject<CCError>()
    
    init(repository: OfferRepositoryProtocol, kmRepository: KeyManagementRepositoryProtocol) {
        self.repository = repository
        self.kmRepository = kmRepository
    }
    
    lazy var offerRedeemEvent: Observable<CCOfferRedeem> = {
        return offerRedeemEventSubject.asObservable()
    }()
    
    lazy var offerEvaluationEvent: Observable<Int> = {
        return offerEvaluationEventSubject.asObservable()
    }()
    
    lazy var requiredScopeEvent: Observable<[CCScopeData]> = {
        return requiredScopeEventSubject.asObservable()
    }()
    
    lazy var errorEvent: Observable<CCError> = {
        return errorEventSubject.asObservable()
    }()
    
    func getOfferRedeem(entityId: String,
                        offerInfo: CCOfferData,
                        listScope: [CCScopeModel]) {
        
        
        if let signing = CoreService.shared.signing {
            var scopeNames = listScope.map { $0.name }
            scopeNames.append("openid")
            let approvalToken = signing
                .generateApprovalToken(id: entityId,
                                       clientId: offerInfo.campaign.consumer?.id ?? "",
                                       scopes: scopeNames,
                                       offerCode: offerInfo.code)
            let standarAndPassiveScopes = listScope.filter{ $0.isStandard || $0.isPassive }
            
            self.repository
                .getOfferRedeem(offerCode: offerInfo.code,
                                scopesNames: scopeNames,
                                persistedScopes: [String](),
                                standarAndPassiveScopes: standarAndPassiveScopes,
                                approvalToken: approvalToken)
                .subscribe(onNext: { [weak self] res in
                    if res.success {
                        self?.offerRedeemEventSubject.onNext(res.data)
                    }else {
                        self?.errorEventSubject.onNext(CCError.unknown)
                    }
                }, onError: { [weak self] err in
                    self?.errorEventSubject.onNext(CCError(error: err))
                    
                })
                .disposed(by: bag)
            
        }else {
            self.errorEventSubject.onNext(CCError.internalError(message: "Cannot get signing key"))
        }
    }
    
    func getOfferEvaluation(offerCode: String,
                            selectedScopes: [CCScopeModel]) {
        if selectedScopes.isEmpty {
            offerEvaluationEventSubject.onNext(0)
        }else {
            let customScopeNames = selectedScopes
                .filter {
                    !$0.isPassive && !$0.isStandard
                }
                .map {
                    $0.name
                }
            
            let passiveScopes = selectedScopes.filter {
                $0.isPassive
            }
            
            _ = repository
                .getOfferEvaluation(offerCode,
                                    customScopeNames: customScopeNames,
                                    passiveScope: passiveScopes)
                .subscribe(onNext: { [weak self] res in
                    if res.success {
                        self?.offerEvaluationEventSubject.onNext(res.data.rank)
                    }else {
                        self?.errorEventSubject.onNext(CCError.unknown)
                    }
                }, onError: { [weak self] (error) in
                    self?.errorEventSubject.onNext(CCError(error: error))
                })
                .disposed(by: bag)
        }
    }
}
