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
        return currency.isEmptyOrNil ? "\(value)" : "\(currency ?? "£")\(value)"
    }
    
    var formattedTotalValue: String {
        return currency.isEmptyOrNil ? "\(totalValue)" : "\(currency ?? "£")\(totalValue)"
    }
}

class ChipSet {
    var name: String
    var stacks: [ChipStack]
    var currency: String?
    
    init(name: String, stacks: [ChipStack] = [], currency: String? = nil) {
        self.name = name
        self.stacks = stacks
        self.currency = currency
    }
    
    var totalValue: Int {
        return stacks.map { $0.value }.reduce(0, +)
    }
    
    var formattedTotalValue: String {
        return currency.isEmptyOrNil ? "\(totalValue)" : "\(currency ?? "£")\(totalValue)"
    }
    
    static func monteCarloChipSet(currency: String = "$") -> ChipSet {
        return .init(name: "Monte Carlo - (\(currency))", stacks: [ChipStack(value: 100, number: 175, currency: currency, title: "Yellow/Black", color: .systemYellow), ChipStack(value: 500, number: 150, currency: currency, title: "Purple", color: .systemPurple), ChipStack(value: 1000, number: 125, currency: currency, title: "Orange/Yellow", color: .systemOrange), ChipStack(value: 5000, number: 50, currency: currency, title: "Pink", color: .systemPink)], currency: currency)
    }
    
    static func random() -> ChipSet {
        let currency = randomCurrency
        let randomNumberOfChipTypes = Int.random(in: 4...10)
        
        var stacks = [ChipStack]()
        
        for value in 1...randomNumberOfChipTypes {
            stacks.append(ChipStack(value: value*100, number: 100, currency: currency, title: nil, color: .random))
        }
        
        return .init(name: "Random - (\(currency))", stacks: stacks, currency: currency)
    }
    
    private static var randomCurrency: String {
        return ["$", "£", "CAD", "NZD", "EUR"].randomElement() ?? ""
    }
}
