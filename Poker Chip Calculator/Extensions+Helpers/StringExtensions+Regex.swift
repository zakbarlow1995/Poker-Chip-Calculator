//
//  StringExtensions+Regex.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation

// https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}

extension String {
    func contains(statusCode: StatusCode) -> Bool {
        return self ~= "\\b\(statusCode.rawValue)[0-9][0-9]\\b"
    }
    
    var containsValidStatusCode: Bool {
        return self ~= "\\b[1-5][0-9][0-9]\\b"
    }
}

enum StatusCode: Int, CaseIterable {
    case oneHundred = 1, twoHundred, threeHundred, fourHundred, fiveHundred
}

// MARK: - Optional<String> Helper methods
extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
    
    var isEmptyOrNil: Bool {
        guard let strongSelf = self else {
            return true
        }
        return strongSelf.isEmpty
    }
}

//https://stackoverflow.com/a/44806984/10623169
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
