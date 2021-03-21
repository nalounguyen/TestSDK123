//
//  CreateNewAccountViewController.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 11/03/2021.
//

import UIKit
import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore

class CreateNewAccountViewController: BaseViewController {
    @IBOutlet weak var cardView: UIView!
    private let tn = "CreateNewAccount"
    private let bag = DisposeBag()
    var presenter: CreateNewAccountPresenterProtocol!
    
    enum InputMode {
        case login
        case register
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleCardLabel: UILabel!
    @IBOutlet weak var userFullNameLbl: UILabel!
    @IBOutlet weak var userPhoneNumberLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var nextButton: CredifyButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    @IBOutlet weak var confirmTermBtn: UIButton!
    @IBOutlet weak var confirmTermViewHeight: NSLayoutConstraint!
    @IBOutlet weak var termAndPrivacyPolicyLabel: UILabel!
    
    
    private var textTerm = ""
    private var textConfirm: String = ""
    private let isConfirmTerm = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.transform = CGAffineTransform(rotationAngle: CGFloat(-16) * CGFloat.pi / CGFloat(180.0))
        bind()
    }
    
    static func instantiate(offerDetail: OfferData) -> CreateNewAccountViewController {
        let sb = UIStoryboard(name: "CreateNewAccount", bundle: Bundle(for: CreateNewAccountViewController.self))
        let vc = sb.instantiateInitialViewController() as! CreateNewAccountViewController
        CreateNewAccountConfigurer.configure(vc: vc, offerDetail: offerDetail)
        return vc
    }
    
    @IBAction func onNextScreen(_ sender: CredifyButton) {
        switch presenter.mode {
        case .login:
            presenter.loginCredifyAccount(credifyId: presenter.credifyId,
                                          password: passwordTextField.text ?? "")
        case .register:
            guard let user = OfferManager.shared.inputUser else { return }
            presenter.createNewAccount(userExternalInfo: user.ccModel,
                                       password: confirmPasswordTextField.text ?? "",
                                       confirmPassword: confirmPasswordTextField.text ?? "")
        }
    }
    
    @IBAction func onConfirmTermAndPolicy(_ sender: UIButton) {
        confirmTermBtn.isSelected = !confirmTermBtn.isSelected
        isConfirmTerm.accept(confirmTermBtn.isSelected)
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true) {
            
        }
    }
    
    override func localization() {
        switch presenter.mode {
        case .login:
            nextButton.setTitle("Login".localized(bundle: .CredifyKit, tableName: tn), for: .normal)
            confirmPasswordView.isHidden = true
            confirmTermViewHeight.constant = 0
            titleLabel.text = "ScreenTitleLogin".localized(bundle: .CredifyKit, tableName: tn)
            
        case .register:
            nextButton.setTitle("Next".localized(bundle: .CredifyKit, tableName: tn), for: .normal)
            confirmPasswordView.isHidden = false
            titleLabel.text = "ScreenTitleCreate".localized(bundle: .CredifyKit, tableName: tn)
        }
        titleCardLabel.text = "DigitalPassport".localized(bundle: .CredifyKit, tableName: tn)
        
        guard let user = presenter.userInfo else { return }
        userFullNameLbl.text = "\(user.firName) \(user.lastName)"
        userEmailLbl.text = user.email
        confirmTermBtn.setImage(UIImage.named("ic_checkbox_gradient_off"), for: .normal)
        confirmTermBtn.setImage(UIImage.named("ic_checkbox_gradient"), for: .selected)
        
        setTermAndPolicyLabel()
    }
    
    private func bind() {
        presenter.nextScreenEvent.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            var allScopes = self.presenter.standarScopesList
            allScopes.append(contentsOf: self.presenter.customScopesList)
            let vc = OfferEvaluationViewController.instantiate(offerDetail: self.presenter.offerInfo, allScopeValues: allScopes)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: bag)
        
        _ = presenter
            .validateInputForCreateNewAccount(password: passwordTextField.rx.text.orEmpty.asDriver(),
                                              confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asDriver(),
                                              confirmTerm: isConfirmTerm.asDriver())
            .drive(nextButton.rx.isEnabled)
    }
    
    private func setTermAndPolicyLabel() {
        textConfirm = "TermOfUseAndPrivacyPolicy".localized(tableName: tn)
        textTerm = "TermOfUse".localized(tableName: tn)
        let underlineAttriString = NSMutableAttributedString(string: textConfirm)
        let termsRange = (textConfirm as NSString).range(of: textTerm)
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.ex.purple,
                                                          .underlineStyle : NSUnderlineStyle.single.rawValue]
        underlineAttriString.addAttributes(attributes, range: termsRange)
        termAndPrivacyPolicyLabel.textColor = UIColor.ex.text
        termAndPrivacyPolicyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termAndPrivacyPolicyLabel.isUserInteractionEnabled = true
        termAndPrivacyPolicyLabel.addGestureRecognizer(tapAction)
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        
        if gesture.didTapAttributedTextInLabel(label: termAndPrivacyPolicyLabel, targetText: textTerm) {
            let vc = WKWebViewViewController.instantiate(url: "https://credify.one/terms-of-use", title: "TermOfUse".localized(tableName: tn))
            present(vc, animated: true)
        }
    }
}
