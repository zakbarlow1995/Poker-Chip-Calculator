//
//  ChipSetDetailCell.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

protocol ChipSetDetailCellDelegate: class {
    func chipStackCellPressed(chipStack: ChipStack)
}

class ChipSetDetailCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    weak var delegate: ChipSetDetailCellDelegate?
    private var chipStack: ChipStack?
    
    lazy var desiredSwatchSize = CGSize(width: contentView.bounds.height - 16.0, height: contentView.bounds.height - 16.0)
    
    let stackDenominationLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .left, numberOfLines: 0, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    let stackCountLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .left, numberOfLines: 0, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    
    let colorSwatch = UIView()
    
    var button = UIButton(backgroundColor: .clear)
    
    @objc func buttonAction() {
        print("DELEGATION - Chip stack button pressed!")
        if let chipStack = self.chipStack {
            delegate?.chipStackCellPressed(chipStack: chipStack)
        }
    }
    
    func configure(with chipStack: ChipStack, delegate: ChipSetDetailCellDelegate) {
        self.chipStack = chipStack
        self.delegate = delegate
        setup()
    }
    
    func setup() {
        setupNameLabel()
        setupOverlayButton()
    }
    
    fileprivate func setupNameLabel() {
        contentView.addSubviews(stackDenominationLabel, stackCountLabel, colorSwatch)
//        stackDenominationLabel.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        stackDenominationLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.centerXAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        colorSwatch.anchor(top: contentView.centerYAnchor, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: -0.5*desiredSwatchSize.height, left: 0, bottom: 0, right: 16), size: desiredSwatchSize)
        stackCountLabel.centerYTo(contentView.centerYAnchor)
        stackCountLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: colorSwatch.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8.0))
        
        if let chipStack = self.chipStack {
            stackDenominationLabel.text = chipStack.formattedValue
            stackCountLabel.text = "×\(chipStack.number)"
            colorSwatch.backgroundColor = chipStack.color
            colorSwatch.cornerRadius = 3.0
        }
    }
    
    fileprivate func setupOverlayButton() {
        contentView.addSubview(button)
        button.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        stackDenominationLabel.text = nil
        stackCountLabel.text = nil
        colorSwatch.backgroundColor = .clear
        chipStack = nil
       
        [stackDenominationLabel, colorSwatch, stackCountLabel].forEach { $0.removeFromSuperview() }
    }
}
