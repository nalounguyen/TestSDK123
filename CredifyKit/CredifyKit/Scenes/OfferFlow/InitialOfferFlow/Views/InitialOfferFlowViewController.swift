//
//  InitialOfferFlowViewController.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 12/03/2021.
//

import UIKit
import RxSwift
import Kingfisher
@_implementationOnly import CredifyCore

class InitialOfferFlowViewController: BaseViewController {
    private let tn = "InitialOfferFlow"
    private let bag = DisposeBag()
    var presenter: InitialOfferFlowPresenterProtocol!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loginedProviderNameLabel: UILabel!
    @IBOutlet private weak var havedCredifyLabel: UILabel!
    
    @IBOutlet private weak var loginedProviderImage: UIImageView!
    @IBOutlet private weak var havedCredifyImage: UIImageView!
    
    @IBOutlet weak var startOfferFlowButton: CredifyButton!
    static func instantiate(offer: OfferData) -> UINavigationController {
        let sb = UIStoryboard(name: "InitialOfferFlow", bundle: Bundle(for: InitialOfferFlowViewController.self))
        let nav = sb.instantiateInitialViewController() as! UINavigationController
        let vc = nav.viewControllers.first! as! InitialOfferFlowViewController
        InitialOfferFlowConfigurer.configure(vc: vc, offerDetail: offer)
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = true
        titleLabel.text = String(format: "ScreenTitle".localized(bundle: .CredifyKit, tableName: tn), presenter.offerInfo.campaign.consumer?.name ?? "")
        loginedProviderNameLabel.text = String(format: "LoggedInTo".localized(bundle: .CredifyKit, tableName: tn), presenter.offerInfo.campaign.consumer?.name ?? "")
        havedCredifyLabel.text = "OwnedDigitalPassport".localized(bundle: .CredifyKit, tableName: tn)
        descriptionLabel.text = "YouAreReady".localized(bundle: .CredifyKit, tableName: tn)
        
        
        havedCredifyImage.image = presenter.offerInfo.credifyId == nil ? UIImage.named("ic_close_red") : UIImage.named("ic_tick_green")
        loginedProviderImage.image = UIImage.named("ic_tick_green")
        
        thumbnailImage.kf.setImage(with: URL(string: presenter.offerInfo.campaign.thumbnailUrl ?? ""))
        startOfferFlowButton.setTitle(presenter.offerInfo.credifyId == nil ? "CreateDigitalPassport".localized(bundle: Bundle.CredifyKit, tableName: tn) : "LoginToDigitalPassport".localized(bundle: Bundle.CredifyKit, tableName: tn), for: .normal)
    }
    
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true) {
        }
    }
    @IBAction func onStartOfferFlow(_ sender: Any) {
        let vc = CreateNewAccountViewController.instantiate(offerDetail: presenter.offerInfo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
