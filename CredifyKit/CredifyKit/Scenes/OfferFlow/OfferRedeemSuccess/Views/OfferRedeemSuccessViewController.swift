//
//  OfferRedeemSuccessViewController.swift
//  Credify
//
//  Created by Nalou Nguyen on 06/01/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class OfferRedeemSuccessViewController: UIViewController {
    private let tn = "OfferRedeemSuccess"
    private let bag = DisposeBag()
    
    @IBOutlet weak var thumbnailView: ViewWithBorder!
    @IBOutlet weak var thumbnailImageView: ImageViewWithBorder!
    @IBOutlet weak var descriptionLabel: CredifyGradientLabel!
    @IBOutlet weak var congratulationLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var timestampValueLabel: UILabel!
    @IBOutlet weak var transactionValueLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var bottomButton: PrimaryButton!
    
    private var offerRedeem: OfferRedeem?
    private var offerInfo: OfferData?
    
    static func instantiate(offerRedeem: OfferRedeem, offerData: OfferData) -> OfferRedeemSuccessViewController {
        let sb = UIStoryboard(name: "OfferRedeemSuccess", bundle: Bundle(for: OfferRedeemSuccessViewController.self))
        let vc = sb.instantiateInitialViewController() as! OfferRedeemSuccessViewController
        vc.offerRedeem = offerRedeem
        vc.offerInfo = offerData
        return vc
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomButton.cornerRadius = Double(bottomButton.bounds.height / 2.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        NavigationBarStyle.style(navigationController, navigationItem: navigationItem, title: "NavTitle".localized(tableName: tn))
        setupDisplay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupDisplay() {
        thumbnailImageView.kf.setImage(with: URL(string: offerInfo?.campaign.thumbnailUrl ?? ""))
        thumbnailView.layer.shadowColor = UIColor.ex.gray.cgColor
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        thumbnailView.layer.shadowRadius = 10.0
        thumbnailView.layer.shadowOpacity = 0.4
        thumbnailView.layer.masksToBounds = false
        
        
        descriptionLabel.text = offerInfo?.campaign.description
        descriptionLabel.font = UIFont.primaryFont(style: .regular, ofSize: 15.0)
        
        congratulationLabel.font = UIFont.primaryFont(style: .regular, ofSize: 13.0)
        congratulationLabel.text = String(format: "CongratulationMessage".localized(tableName: tn), offerInfo?.campaign.consumer?.name ?? "")
        
        detailLabel.font = UIFont.primaryFont(style: .regular, ofSize: 13.0)
        detailLabel.text = "Details".localized(tableName: tn)
        detailLabel.textColor = UIColor.ex.purple
        
        timestampLabel.font = UIFont.primaryFont(style: .regular, ofSize: 13.0)
        timestampLabel.text = "Timestamp".localized(tableName: tn)
        timestampLabel.textColor = UIColor.ex.secondaryText
        
        transactionLabel.font = UIFont.primaryFont(style: .regular, ofSize: 13.0)
        transactionLabel.text = "TransactionID".localized(tableName: tn)
        transactionLabel.textColor = UIColor.ex.secondaryText
        
        timestampValueLabel.font = UIFont.primaryFont(style: .regular, ofSize: 14.0)
        let date = offerRedeem?.approval?.appliedAt?.toDate()
        timestampValueLabel.text = "\(date?.toLocalizedDate(withFormat: "dd/MM/yyyy") ?? "") - \(date?.toLocalizedDate(withFormat: "HH:mm") ?? "")"
        
        transactionValueLabel.font = UIFont.primaryFont(style: .regular, ofSize: 14.0)
        transactionValueLabel.text = offerRedeem?.approval?.id ?? ""
        
        supportLabel.font = UIFont.primaryFont(style: .regular, ofSize: 15.0)
        supportLabel.text = String(format: "SupportMessage".localized(tableName: tn), offerInfo?.campaign.consumer?.name ?? "")
        
        bottomButton.setTitle(String(format: "goToConsumerWebsite".localized(tableName: tn), offerInfo?.campaign.consumer?.name ?? ""), for: .normal)
        
        

    }
    
    @IBAction func goToWebsite(_ sender: UIButton) {
        guard let url = offerInfo?.campaign.consumer?.appUrlStr else {
            return
        }
        
        let vc = WKWebViewViewController.instantiate(url: url, title: "")
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
