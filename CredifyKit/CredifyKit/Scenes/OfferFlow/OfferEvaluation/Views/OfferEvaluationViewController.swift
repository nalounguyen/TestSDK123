//
//  OfferEvaluationViewController.swift
//  Credify
//
//  Created by Nalou Nguyen on 11/12/2020.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class OfferEvaluationViewController: BaseViewController {
    private let tn = "OfferEvaluation"
    private let bag = DisposeBag()
    var presenter: OfferEvaluationPresenterProtocol!
    
    enum SectionType: Int {
        case thumbnail, scope
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var evaluationButton: PrimaryButton!
    
    /// Ratio for layout
    private let RATIO_OFFER_HEADER_HEIGHT = 100.0/630.0
    
    private let requiredScopeEventSubject = BehaviorRelay<[(scope: ScopeModel, isSelected: Bool)]>(value: [])
    private var offerPromotion = BehaviorRelay<OfferBenefitHeaderView.OfferMode>(value: .needMoreInfo)
    
    
    private let RATIO_THUMBNAIL_CELL = 269.0/812.0

    static func instantiate(offerDetail: OfferData, allScopeValues: [ScopeModel]) -> OfferEvaluationViewController {
        let sb = UIStoryboard(name: "OfferEvaluation", bundle: Bundle(for: OfferEvaluationViewController.self))
        let vc = sb.instantiateInitialViewController() as! OfferEvaluationViewController
        OfferEvaluationConfigurer.configure(vc: vc,
                                            offerDetail: offerDetail,
                                            allScopeValues: allScopeValues)
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: OfferBenefitHeaderView.id,
                                 bundle: Bundle(for: OfferBenefitHeaderView.self)),
                           forHeaderFooterViewReuseIdentifier: OfferBenefitHeaderView.id)
        tableView.register(UINib(nibName: OfferScopeTableViewCell.id,
                                 bundle: Bundle(for: OfferScopeTableViewCell.self)),
                           forCellReuseIdentifier: OfferScopeTableViewCell.id)
        tableView.register(UINib(nibName: OfferThumbnailTableViewCell.id,
                                 bundle: Bundle(for: OfferThumbnailTableViewCell.self))
                           , forCellReuseIdentifier: OfferThumbnailTableViewCell.id)
//        NavigationBarStyle.style(navigationController, navigationItem: navigationItem, title: "Offers".localized(tableName: tn))
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1;
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDisplay()
    }
    
    @IBAction func evaluationAction(_ sender: PrimaryButton) {
        presenter.getOfferRedeem()
    }
    
    func setupDisplay() {
        evaluationButton.cornerRadius = Double(evaluationButton.bounds.height / 2)
        evaluationButton.setBackgroundColor(UIColor.ex.grayText, forState: .disabled)
        evaluationButton.isEnabled = false
        evaluationButton.setTitle("RedeemOffer".localized(tableName: tn), for: .normal)
    }
    
    private func bind() {
        _ = offerPromotion.map {
            switch $0 {
            case .needMoreInfo: return false
            case .offer: return true
            }
        }.bind(to: evaluationButton.rx.isEnabled)
        
        presenter.offerEvaluationEvent
            .drive(onNext: { [weak self] offerPromotion in
                self?.offerPromotion.accept(offerPromotion)
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        presenter.requiredScopesEvent
            .drive(onNext: { [weak self] list in
                self?.requiredScopeEventSubject.accept(list)
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        presenter.directToResultPageEvent
            .drive(onNext: { [weak self] url in
                guard let self = self else { return }
                let vc = WKWebViewViewController.instantiate(url: url.absoluteString, title: "")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        presenter.goToSuccessScreenEvent
            .drive(onNext: { [weak self] offerRedeem in
                guard let self = self else { return }
                let vc = OfferRedeemSuccessViewController.instantiate(offerRedeem: offerRedeem,
                                                                      offerData: self.presenter.offerInfo)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
    
}

extension OfferEvaluationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionType(rawValue: section) else { return 0 }
        switch section {
        case .thumbnail: return 1
        case .scope: return requiredScopeEventSubject.value.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .thumbnail:
            let cell = tableView.dequeueReusableCell(withIdentifier: OfferThumbnailTableViewCell.id, for: indexPath) as! OfferThumbnailTableViewCell
            cell.thumbnailImageView.kf.setImage(with: URL(string: presenter.offerInfo.campaign.thumbnailUrl ?? ""))
            cell.descriptionLabel.text = presenter.offerInfo.campaign.description
            return cell
            
        case .scope:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.secondaryFont(style: .regular, ofSize: 15.0)
                cell.textLabel?.text = String(format: "DescriptionOffer".localized(tableName: tn), presenter.offerInfo.campaign.consumer?.name ?? "")
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = UIColor.ex.primaryText
                cell.backgroundColor = .clear
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: OfferScopeTableViewCell.id, for: indexPath) as! OfferScopeTableViewCell
                if requiredScopeEventSubject.value[indexPath.row - 1].scope.isPassive || requiredScopeEventSubject.value[indexPath.row - 1].scope.isStandard {
                    cell.isUserInteractionEnabled = false
                }else {
                    cell.isUserInteractionEnabled = true
                }
                cell.configCell(with: requiredScopeEventSubject.value[indexPath.row - 1])
                cell.onSelectionAction = { [weak self] isSelected in
                    guard let self = self else { return }
                    self.presenter.evaluateOffer(index: indexPath.row - 1)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = SectionType(rawValue: section) else { return nil}
        switch section {
        case .thumbnail: return nil
        case .scope:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: OfferBenefitHeaderView.id) as! OfferBenefitHeaderView
            header.updateOffer(offerPromotion.value)
            return header
        }
        
    }
}

extension OfferEvaluationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = SectionType(rawValue: section) else { return 0 }
        switch section {
        case .thumbnail:
            return 0
        case .scope:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .thumbnail: break
        case .scope:
            if indexPath.row != 0 {
                self.presenter.evaluateOffer(index: indexPath.row - 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionType(rawValue: indexPath.section) else { return 0.1 }
        switch section {
        case .thumbnail:
            return tableView.estimatedRowHeight
        case .scope:
            return tableView.estimatedRowHeight
        }
    }
}
