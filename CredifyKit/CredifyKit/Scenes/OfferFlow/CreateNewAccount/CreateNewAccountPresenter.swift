//
//  CreateNewAccountPresenter.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 11/03/2021.
//

import Foundation

import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore

protocol CreateNewAccountPresenterProtocol {
    var offerInfo: OfferData { get }
    var nextScreenEvent: Driver<Void> { get }
    var mode: CreateNewAccountViewController.InputMode { get }
    var standarScopesList: [ScopeModel] { get }
    var customScopesList: [ScopeModel] { get }
    var credifyId: String { get }
    var userInfo: UserExternalModel? { get }
    
    // Create new account's Credify
    func createNewAccount(userExternalInfo: CCUserExternalModel, password: String, confirmPassword: String)
    func loginCredifyAccount(credifyId: String, password: String)
    
    func validateInputForCreateNewAccount(password: Driver<String>,
                                          confirmPassword: Driver<String>,
                                          confirmTerm: Driver<Bool>) -> Driver<Bool>
}

class CreateNewAccountPresenter: CreateNewAccountPresenterProtocol {

    
    private let bag = DisposeBag()
    private let useCase: ProviderUseCaseProtocol
    private let claimUseCase: ClaimUseCaseProtocol
    private var offerDetail: OfferData
    private var standarScopes: [ScopeModel] = [ScopeModel]() 
    private var customScopes: [ScopeModel] = [ScopeModel]()
    
    private let nextScreenEventSubject = PublishSubject<Void>()
    
    
    init(useCase: ProviderUseCaseProtocol, claimUseCase: ClaimUseCaseProtocol, offerDetail: OfferData) {
        self.useCase = useCase
        self.offerDetail = offerDetail
        self.claimUseCase = claimUseCase
        
        bind()
    }
    
    var userInfo: UserExternalModel? {
        OfferManager.shared.inputUser
    }
    
    var offerInfo: OfferData {
        return offerDetail
    }
    
    var standarScopesList: [ScopeModel] {
        return standarScopes
    }
    var customScopesList: [ScopeModel] {
        return customScopes
    }
    
    var credifyId: String {
        return offerDetail.credifyId ?? ""
    }
    
    var mode: CreateNewAccountViewController.InputMode {
        if offerDetail.credifyId == nil {
            return CreateNewAccountViewController.InputMode.register
        }else {
            return CreateNewAccountViewController.InputMode.login
        }
    }
    
    lazy var nextScreenEvent: Driver<Void> = {
        return nextScreenEventSubject.asDriver(onErrorJustReturn: ())
    }()
    
    func createNewAccount(userExternalInfo: CCUserExternalModel,
                          password: String,
                          confirmPassword: String) {
        
        if password == confirmPassword,
           let validPass = try? password.checkPassword() {
            LoadingView.start()
            useCase.getCredifyIdFromProvider(userExternalInfo: userExternalInfo,
                                             password: validPass)
        }else {
            
        }
        
    }
    
    func loginCredifyAccount(credifyId: String, password: String) {
        useCase.loginWithPassword(mode: .withCredifyId(id: credifyId), password: password)
        
    }
    
    func validateInputForCreateNewAccount(password: Driver<String>,
                                          confirmPassword: Driver<String>,
                                          confirmTerm: Driver<Bool>) -> Driver<Bool> {
        
        
        Driver.combineLatest(password, confirmPassword, confirmTerm) { password, confirmPassword, confirmTerm  in
            return !password.isEmpty && !confirmPassword.isEmpty && confirmTerm
        }
    }
    
    private func bind() {
        useCase.loginSuccessEvent
            .subscribe(onNext: { [weak self] _ in
                print("login successed!!")
                self?.claimUseCase.getEncryptedClaim()
            })
            .disposed(by: bag)
        
        useCase.errorEvent
            .subscribe(onNext: { err in
                LoadingView.stop()
                err.displayAlert()
                print(err)
            })
            .disposed(by: bag)
        
        claimUseCase.getEncryptedClaimEvent
            .subscribe(onNext: { [weak self] listClaim in
                guard let self = self else { return }
                self.standarScopes = listClaim.map { item in
                    return ScopeModel(from: item)
                }
                self.claimUseCase.getAttachedCustomClaims(providerId: self.offerDetail.providerId)
            })
            .disposed(by: bag)
        
        claimUseCase.getCustomScopeEvent
            .subscribe(onNext: { [weak self] listCustomScope in
                guard let self = self else { return }
                self.customScopes = listCustomScope.map({ return ScopeModel(from: $0)})
                LoadingView.stop()
                self.nextScreenEventSubject.onNext(())
            })
            .disposed(by: bag)
        
        useCase.credifyIdEvent
            .subscribe { [weak self] info in
                guard let self = self else { return }
                self.useCase
                    .loginWithPassword(mode: .withCredifyId(id: info.credifyId),
                                       password: info.password)
                self.offerDetail.credifyId = info.credifyId
            } onError: { err in
                err.displayAlert()
                print(err)
            }
            .disposed(by: bag)
        
        
        // Errors
        claimUseCase.errorEvent
            .subscribe(onNext: { err in
                print(err)
                err.displayAlert()
                LoadingView.stop()
            })
            .disposed(by: bag)
        
        useCase.errorEvent
            .subscribe(onNext: { (err) in
                LoadingView.stop()
                err.displayAlert()
                
            })
            .disposed(by: bag)

    }
    
    deinit {
        print("\(self) is deinit")
    }
}





