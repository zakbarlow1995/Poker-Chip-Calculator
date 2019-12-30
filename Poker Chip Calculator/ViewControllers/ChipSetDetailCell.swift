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
    
    let stackDenominationLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .left, numberOfLines: 1, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    let stackCountLabel = UILabel(font: UIFont.systemFont(ofSize: 24.0, weight: .bold), textColor: .systemGray, textAlignment: .right, numberOfLines: 1, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    
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
        stackCountLabel.anchor(top: nil, leading: stackDenominationLabel.trailingAnchor, bottom: nil, trailing: colorSwatch.leadingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 8.0))
        
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


protocol ChipSetDetailFooterDelegate: class {
    func calculateByGroupButtonPressed()
    func calculateByPersonButtonPressed()
}

class ChipSetDetailFooter: UIView {
    
    weak var delegate: ChipSetDetailFooterDelegate?
    
    lazy var desiredButtonSize = CGSize(width: bounds.width - 32.0, height: 0.5*bounds.height - 16.0)
    
    lazy var calculateByGroupButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: desiredButtonSize))
        btn.backgroundColor = Colors.blueGreen
        btn.setTitle("Calculate By Group", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        btn.titleLabel?.numberOfLines = 1
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.cornerRadius = desiredButtonSize.height/2.0
        btn.addTarget(self, action: #selector(calculateByGroupButtonAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func calculateByGroupButtonAction() {
        print("DELEGATION - calculateByGroupButton pressed!")
        delegate?.calculateByGroupButtonPressed()
    }
    
    lazy var calculateByPersonButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: desiredButtonSize))
        btn.backgroundColor = Colors.blueGreen
        btn.setTitle("Calculate By Person", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        btn.titleLabel?.numberOfLines = 1
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.cornerRadius = desiredButtonSize.height/2.0
        btn.addTarget(self, action: #selector(calculateByPersonButtonAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func calculateByPersonButtonAction() {
        print("DELEGATION - calculateByPersonButton pressed!")
        delegate?.calculateByPersonButtonPressed()
    }
    
    convenience init(footerHeight: CGFloat, delegate: ChipSetDetailFooterDelegate) {
        self.init()
        self.desiredButtonSize.height = 0.5*footerHeight - 16.0
        self.configure(with: delegate)
    }
    
    private func configure(with delegate: ChipSetDetailFooterDelegate) {
        self.delegate = delegate
        setupButtons()
    }
    
    fileprivate func setupButtons() {
        addSubviews(calculateByGroupButton, calculateByPersonButton)
        calculateByGroupButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: centerYAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        calculateByPersonButton.anchor(top: centerYAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        calculateByGroupButton.addTarget(self, action: #selector(calculateByGroupButtonAction), for: .touchUpInside)
        calculateByPersonButton.addTarget(self, action: #selector(calculateByPersonButtonAction), for: .touchUpInside)
    }
}
