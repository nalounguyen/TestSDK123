//
//  OfferScopeTableViewCell.swift
//  Credify
//
//  Created by Nalous Nguyen on 12/9/20.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class OfferScopeTableViewCell: UITableViewCell {
    static let id = "OfferScopeTableViewCell"
    private let bag = DisposeBag()
    @IBOutlet weak var checkButton: ButtonWithBorder!
    @IBOutlet weak var scopeNameLabel: UILabel!
    @IBOutlet weak var listClaimStackView: UIStackView!
    @IBOutlet weak var backgroundViewCell: ViewWithBorder!
    
    @IBOutlet weak var selectButton: UIButton!
    var onSelectionAction: ((_ isSelected: Bool) -> Void)?
    var item: ScopeData?
    
    var isChecked: Bool = true {
        didSet {
            backgroundViewCell.backgroundColor = isChecked ? UIColor.clear : UIColor.ex.borderLightGray
            
            checkButton.setBackgroundImage(isChecked == false ? UIImage.named("ic_checkbox_gradient") : UIImage.named("ic_checkbox_gradient_off"),
                                 for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundViewCell.backgroundColor = isChecked ? UIColor.clear : UIColor.ex.borderLightGray
        scopeNameLabel.textColor = UIColor.ex.black
        scopeNameLabel.font = UIFont.secondaryFont(style: .bold, ofSize: 15.0)
        selectButton.rx.tap
            .asDriver()
            .drive(onNext: {  [weak self] _ in
                guard let self = self else { return }
                self.onSelectionAction?(!self.isChecked)
            })
            .disposed(by: bag)
    }
    
    @IBAction func selectAction(_ sender: ButtonWithBorder) {
        isChecked = !isChecked
        onSelectionAction?(isChecked)
    }
    
    func configCell(with data:(scope: ScopeModel, isSelected: Bool)) {
        listClaimStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        isChecked = !data.isSelected
        if data.scope.isPassive || data.scope.isStandard{
            scopeNameLabel.textColor = UIColor.ex.secondaryText
            scopeNameLabel.text = data.scope.name
            self.isUserInteractionEnabled = false
            checkButton.setBackgroundImage(UIImage.named("ic_checkbox_disable"), for: .normal)
            
            
        }else {
            scopeNameLabel.textColor = UIColor.ex.black
            scopeNameLabel.text = data.scope.displayName
            self.isUserInteractionEnabled = true
        }
        for claimItem in data.scope.claims {
            if claimItem.isPassiveClaim || claimItem.isStandardClaim {
                self.setupClaim(claimKey: claimItem.claimName, claimValue: claimItem.claimValue)
            }else {
                self.setupClaim(claimKey: claimItem.displayName ?? "", claimValue: claimItem.claimValue)
            }
            
        }
        
        
        
    }
    // Create View for each claims
    private func setupClaim(claimKey: String, claimValue: Any) {
        let claimView = UIView(frame: .zero)
        claimView.backgroundColor = .clear
        listClaimStackView.addArrangedSubview(claimView)
        let leftLabel = UILabel(frame: .zero)
        let rightLabel = UILabel(frame: .zero)
        
        leftLabel.text = claimKey
        leftLabel.textColor = UIColor.ex.secondaryText
        leftLabel.font = UIFont.secondaryFont(ofSize: 15.0)
        leftLabel.textAlignment = .left
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.minimumScaleFactor = 0.5
        leftLabel.adjustsFontSizeToFitWidth = true
        claimView.addSubview(leftLabel)
        
        rightLabel.text = "\(claimValue)"
        rightLabel.textColor = UIColor.ex.secondaryText
        rightLabel.font = UIFont.secondaryFont(ofSize: 15.0)
        rightLabel.textAlignment = .right
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.minimumScaleFactor = 0.5
        rightLabel.adjustsFontSizeToFitWidth = true
        claimView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([claimView.heightAnchor.constraint(equalToConstant: 20)])
        
        NSLayoutConstraint.activate([
            leftLabel.widthAnchor.constraint(lessThanOrEqualToConstant: listClaimStackView.frame.width * 0.5),
            leftLabel.topAnchor.constraint(equalTo: claimView.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: claimView.bottomAnchor),
            leftLabel.leftAnchor.constraint(equalTo: claimView.leftAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.topAnchor.constraint(equalTo: claimView.topAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: claimView.bottomAnchor),
            rightLabel.leftAnchor.constraint(equalTo: leftLabel.rightAnchor, constant: 0),
            rightLabel.rightAnchor.constraint(equalTo: claimView.rightAnchor, constant: 0),
        ])
        
        
    }
    
}
