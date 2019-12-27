//
//  ChipStack.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

class ChipStack {
    let value: Int
    var number: Int
    let currency: String?
    let title: String?
    let color: UIColor?
    
    init(value: Int, number: Int, currency: String? = nil, title: String? = nil, color: UIColor? = nil) {
        self.value = value
        self.number = number
        self.currency = currency
        self.title = title
        self.color = color
    }
    
    var totalValue: Int {
        return value * number
    }
    
    var formattedValue: String {
        return currency.isEmptyOrNil ? "\(value)" : "\(currency ?? "$")\(value)"
    }
}
