//  Copyright (c) 2017 9elements GmbH <contact@9elements.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

protocol Numeric: Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    var value: Double { set get }
    init(_ value: Double)
}

func %<T: Numeric> (lhs: T, rhs: T) -> T {
    return T(lhs.value.truncatingRemainder(dividingBy: rhs.value))
}

func + <T: Numeric> (lhs: T, rhs: T) -> T {
    return T(lhs.value + rhs.value)
}

func - <T: Numeric> (lhs: T, rhs: T) -> T {
    return T(lhs.value - rhs.value)
}

func < <T: Numeric> (lhs: T, rhs: T) -> Bool {
    return lhs.value < rhs.value
}

func == <T: Numeric> (lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

prefix func - <T: Numeric> (number: T) -> T {
    return T(-number.value)
}

func += <T: Numeric> (lhs: inout T, rhs: T) {
    lhs.value = lhs.value + rhs.value
}

func -= <T: Numeric> (lhs: inout T, rhs: T) {
    lhs.value = lhs.value - rhs.value
}

struct DisplayP3Value: Numeric {
    var value: Double

    init(_ value: Double) {
        self.value = value
    }
}

extension DisplayP3Value: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(Double(value))
    }
}

extension DisplayP3Value: ExpressibleByFloatLiteral {
    init(floatLiteral value: FloatLiteralType) {
        self.init(Double(value))
    }
}

struct ExtendedSRGBValue: Numeric {
    var value: Double

    init(_ value: Double) {
        self.value = value
    }
}

extension ExtendedSRGBValue: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(Double(value))
    }
}

extension ExtendedSRGBValue: ExpressibleByFloatLiteral {
    init(floatLiteral value: FloatLiteralType) {
        self.init(Double(value))
    }
}
