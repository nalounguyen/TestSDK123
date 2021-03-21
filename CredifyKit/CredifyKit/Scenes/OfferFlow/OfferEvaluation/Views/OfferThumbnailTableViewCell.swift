//
//  OfferThumbnailTableViewCell.swift
//  Credify
//
//  Created by Nalou Nguyen on 11/12/2020.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit

class OfferThumbnailTableViewCell: UITableViewCell {
    static let id = "OfferThumbnailTableViewCell"
    
    @IBOutlet weak var descriptionLabel: CredifyGradientLabel!
    @IBOutlet weak var thumbnailImageView: ImageViewWithBorder!
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.font = UIFont.secondaryFont(style: .regular, ofSize: 15.0)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        contentView.layer.shadowColor = UIColor.ex.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        contentView.layer.shadowRadius = 10.0
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
