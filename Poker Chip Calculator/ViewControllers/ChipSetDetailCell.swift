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
    
    let stackLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .left, numberOfLines: 0, sizeToFit: true, adjustsFontSizeToFitWidth: true)
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
        contentView.addSubview(stackLabel)
        stackLabel.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        if let chipStack = self.chipStack {
            stackLabel.text = chipStack.formattedValue + "x\(chipStack.number)"
            contentView.backgroundColor = chipStack.color
        }
    }
    
    fileprivate func setupOverlayButton() {
        contentView.addSubview(button)
        button.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        stackLabel.text = nil
        chipStack = nil
        stackLabel.removeFromSuperview()
    }
}
