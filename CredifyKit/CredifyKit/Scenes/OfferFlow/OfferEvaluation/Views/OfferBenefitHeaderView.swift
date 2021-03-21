//
//  OfferBenefitHeaderView.swift
//  Credify
//
//  Created by Nalou Nguyen on 11/12/2020.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit

class OfferBenefitHeaderView: UITableViewHeaderFooterView {
    static let id = "OfferBenefitHeaderView"
    private let tn = "OfferEvaluation"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var background: ViewWithBorder!
    @IBOutlet private weak var benefitDescriptionLabel: CredifyGradientLabel!
    enum OfferMode {
        case needMoreInfo
        case offer(description: String)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.shadowColor = UIColor.ex.gray.cgColor
        background.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        background.layer.shadowRadius = 10.0
        background.layer.shadowOpacity = 0.4
        background.layer.masksToBounds = false
        self.tintColor = .clear
        
        benefitDescriptionLabel.font = UIFont.secondaryFont(style: .regular, ofSize: 14)
        benefitDescriptionLabel.startColor = UIColor.ex.secondaryText
        benefitDescriptionLabel.endColor = UIColor.ex.secondaryText
        titleLabel.text = "DataToBeShared".localized(bundle: Bundle(for: OfferBenefitHeaderView.self), tableName: tn)
        titleLabel.font = UIFont.secondaryFont(style: .regular, ofSize: 14)
        titleLabel.textColor = UIColor.ex.secondaryText
    }
    
    func updateOffer(_ offerMode: OfferMode) {

        switch offerMode {
        case .needMoreInfo:
            benefitDescriptionLabel.text = "RequireConnect".localized(tableName: tn)
            benefitDescriptionLabel.startColor = UIColor.ex.secondaryText
            benefitDescriptionLabel.endColor = UIColor.ex.secondaryText
            break
        case .offer(let description):
            benefitDescriptionLabel.startColor = UIColor.ex.purple
            benefitDescriptionLabel.endColor = UIColor.ex.purple
            benefitDescriptionLabel.horizontalGradientMode = true
            benefitDescriptionLabel.text = description
            
            break
        }
    }
    
}
