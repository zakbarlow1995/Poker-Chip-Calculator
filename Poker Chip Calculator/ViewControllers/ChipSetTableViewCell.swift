//
//  ChipSetTableViewCell.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

protocol ChipSetTableViewCellDelegate: class {
    func chipSetTableViewCellPressed(for chipSet: ChipSet)
}

class ChipSetTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    weak var delegate: ChipSetTableViewCellDelegate?
    private var chipSet: ChipSet?
    
    let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .left, numberOfLines: 0, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    var button = UIButton(backgroundColor: .clear)
    
    @objc func buttonAction() {
        print("DELEGATION - Chip set button pressed!")
        if let chipSet = self.chipSet {
            delegate?.chipSetTableViewCellPressed(for: chipSet)
        }
    }
    
    func configure(with chipSet: ChipSet, delegate: ChipSetTableViewCellDelegate) {
        self.chipSet = chipSet
        self.delegate = delegate
        setup()
    }
    
    func setup() {
        setupNameLabel()
        setupOverlayButton()
    }
    
    fileprivate func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        nameLabel.text = chipSet?.name
    }
    
    fileprivate func setupOverlayButton() {
        contentView.addSubview(button)
        button.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        chipSet = nil
        nameLabel.removeFromSuperview()
    }
}
