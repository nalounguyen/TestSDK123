//
//  OfferEvaluationPresenter.swift
//  Credify
//
//  Created by Nalou Nguyen on 11/12/2020.
//  Copyright © 2020 Credify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore

protocol OfferEvaluationPresenterProtocol {
    /// All required scope for offer
    var requiredScopesEvent: Driver<[(scope: ScopeModel, isSelected: Bool)]> { get }
    /// Offer Information
    var offerInfo: OfferData { get }
    var offerEvaluationEvent: Driver<OfferBenefitHeaderView.OfferMode> { get }
    var directToResultPageEvent: Driver<URL> { get }
    var goToSuccessScreenEvent: Driver<OfferRedeem> { get }
    
    func evaluateOffer(index: Int)
    func getOfferRedeem()
}

class OfferEvaluationPresenter: OfferEvaluationPresenterProtocol {
    private let bag = DisposeBag()
    private let useCase: OfferUseCaseProtocol
    private let offerDetail: OfferData
                
//    private let allStandarScopes : [ScopeModel]
//    private let allPassiveScopes : [ScopeModel]
    private let allScopesEventSubject = BehaviorRelay<[ScopeModel]>(value: [])
    private let requiredScopesEventSubject = BehaviorRelay<[(scope: ScopeModel, isSelected: Bool)]>(value: [])
    private let offerEvaluationEventSubject = BehaviorRelay<OfferBenefitHeaderView.OfferMode>(value: .needMoreInfo)
    private let directToResultPageEventSubject = PublishSubject<URL>()
    private var currentSellected: Int = 0
    private let getOfferEvaluationSubject = BehaviorRelay<Void>(value: ())
    private let goToSuccessScreenEventSubject = PublishSubject<OfferRedeem>()
    
    init(useCase: OfferUseCaseProtocol, offerDetail: OfferData, allScopeValues: [ScopeModel]) {
        self.useCase = useCase
        self.offerDetail = offerDetail
//        self.allStandarScopes = allScopeValues.filter({ $0.isStandard })
//        self.allPassiveScopes = allScopeValues.filter({ $0.isPassive })
        
        bind()
        self.allScopesEventSubject.accept(allScopeValues)
    }
    
    //MARK: - Properties
    var offerInfo: OfferData {
        return offerDetail
    }
    
    lazy var offerEvaluationEvent: Driver<OfferBenefitHeaderView.OfferMode> = {
        return offerEvaluationEventSubject.asDriver()
    }()
    
    lazy var requiredScopesEvent: Driver<[(scope: ScopeModel, isSelected: Bool)]> = {
        return requiredScopesEventSubject
            .map { [weak self] model -> [(scope: ScopeModel, isSelected: Bool)] in
                return model
                    .map { item -> (scope: ScopeModel, isSelected: Bool) in
                        // Remove commitment passive claims
                        let claims = item.scope.claims.filter {
                            $0.claimName != "\($0.scopeName):commitment" &&
                                $0.claimName != "\($0.scopeName)_commitment"
                        }
                        let scope = ScopeModel(name: item.scope.name, claims: claims, displayName: item.scope.displayName)
                        return (scope: scope, isSelected: item.isSelected)
                    }
            }
            .asDriver(onErrorJustReturn: [(scope: ScopeModel, isSelected: Bool)]())
    }()
    
    lazy var directToResultPageEvent: Driver<URL> = {
        return directToResultPageEventSubject.asDriver(onErrorDriveWith: Driver.empty())
    }()
    
    lazy var goToSuccessScreenEvent: Driver<OfferRedeem> = {
        return goToSuccessScreenEventSubject.asDriver(onErrorDriveWith: Driver.empty())
    }()
    
    //MARK: - Functions
    func evaluateOffer(index: Int) {
        currentSellected = index
        let list = calculateSelectedOffer()
        self.requiredScopesEventSubject.accept(list)
        getOfferEvaluationSubject.accept(())
    }
    
    func getOfferRedeem() {
        LoadingView.start()
        let selectedScopes = requiredScopesEventSubject.value
                                .filter { $0.isSelected }
                                .map { $0.scope.ccModel }
        

        useCase.getOfferRedeem(entityId: offerDetail.credifyId ?? "", offerInfo: offerDetail.ccModel, listScope: selectedScopes)
    }
    
    private func calculateSelectedOffer() -> [(scope: ScopeModel, isSelected: Bool)]  {
        var list = requiredScopesEventSubject.value
        
        for index in (0..<requiredScopesEventSubject.value.count) {
            if list[currentSellected].isSelected {
                if index >= currentSellected {
                    list[index].isSelected = !list[currentSellected].isSelected
                }else {
                    
                }
            }else {
                if index <= currentSellected {
                    list[index].isSelected = !list[currentSellected].isSelected
                }else {
                    list[index].isSelected = false
                }
            }
        }
        return list
    }
    
    //MARK: - Binding from useCases
    private func bind() {
        getOfferEvaluationSubject
            .asDriver()
            .debounce(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let list = self.requiredScopesEventSubject.value
                let scopeSelected = list.filter { $0.isSelected }.map { $0.scope.ccModel }
                self.useCase.getOfferEvaluation(offerCode: self.offerDetail.code, selectedScopes: scopeSelected)
            })
            .disposed(by: bag)
        
        allScopesEventSubject.subscribe(onNext: { [weak self] allScopes in
            guard let self = self else { return }
            let result = allScopes.filter {
                $0.isPassive || $0.isStandard || self.offerDetail.evaluationResult.requiredScopes.contains($0.name)
            }
            self.requiredScopesEventSubject.accept(result.map({ ($0, true) }))
        }).disposed(by: bag)
        
        useCase.errorEvent
            .subscribe(onNext: { error in
                LoadingView.stop()
                error.displayAlert()
            })
            .disposed(by: bag)
        
        useCase.offerEvaluationEvent
            .subscribe(onNext: { [weak self] level in
                guard let self = self else { return }
                if level == 0 {
                    self.offerEvaluationEventSubject.accept(.needMoreInfo)
                }else {
                    self.offerEvaluationEventSubject.accept(.offer(description: self.offerDetail.campaign.levels?[level-1] ?? ""))
                }
            }).disposed(by: bag)
        
        useCase.offerRedeemEvent
            .subscribe(onNext: { [weak self] data in
                LoadingView.stop()
                if let extraSteps = self?.offerDetail.campaign.extraSteps,
                   let url = data.redirectUrl {
                    self?.directToResultPageEventSubject.onNext(url)
                }else {
                    let model = OfferRedeem.convert(from: data)
                    self?.goToSuccessScreenEventSubject.onNext(model)
                }
            })
            .disposed(by: bag)
    }
    
    deinit {
        print("\(self) is deinit")
    }
}
