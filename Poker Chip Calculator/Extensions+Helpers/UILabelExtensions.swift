//
//  UILabelExtensions.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience public init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1, sizeToFit: Bool? = nil, adjustsFontSizeToFitWidth: Bool? = nil, isHidden: Bool = false) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.isHidden = isHidden
        if sizeToFit ?? false {
            self.sizeToFit()
        }
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
    }
}
