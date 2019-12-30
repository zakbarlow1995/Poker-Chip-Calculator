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

import Foundation
import UIKit

/// A struct that wraps values for `hue`, `saturation` and `brightness`.
struct HSB {
    /// The hue value.
    let hue: ExtendedSRGBValue

    /// The saturation value.
    let saturation: ExtendedSRGBValue

    /// The brightness value.
    let brightness: ExtendedSRGBValue
}

extension UIColor {
    /// Returns the hue, saturation and brightness values for the receiver.
    internal var hsb: HSB {
        let model = cgColor.colorSpace!.model
        if let c = cgColor.components, model == .monochrome {
            return HSB(
                hue: 0,
                saturation: 0,
                brightness: ExtendedSRGBValue(Double(c[0]))
            )
        } else if let c = cgColor.components, model == .rgb {
            let x = min(min(c[0], c[1]), c[2])
            let b = max(max(c[0], c[1]), c[2])

            if b == x {
                return HSB(
                    hue: 0,
                    saturation: 0,
                    brightness: ExtendedSRGBValue(Double(b))
                )
            } else {
                let f: CGFloat
                let i: CGFloat

                if c[0] == x {
                    f = c[1] - c[2]
                    i = 3
                } else if c[1] == x {
                    f = c[2] - c[0]
                    i = 5
                } else {
                    f = c[0] - c[1]
                    i = 1
                }

                // Split into multiple lines to improve build times
                var hue = b - x
                hue = f / hue
                hue = i - hue
                hue = hue / 6

                // Split into multiple lines to improve build times
                var saturation = b - x
                saturation = saturation / b

                let brightness = b

                return HSB(
                    hue: ExtendedSRGBValue(Double(hue)),
                    saturation: ExtendedSRGBValue(Double(saturation)),
                    brightness: ExtendedSRGBValue(Double(brightness))
                )
            }
        }

        return HSB(hue: 0, saturation: 0, brightness: 0)
    }

    internal class var transparentPattern: UIColor? {
        let bundle = Bundle(for: ColorPickerView.self)

        guard let resourceURL = bundle.url(forResource: "IMGLYColorPicker", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceURL),
            let patternImage = UIImage(named: "transparent_color_pattern", in: resourceBundle, compatibleWith: nil) else {
                return nil
        }

        return UIColor(patternImage: patternImage)
    }

    internal convenience init(deviceDependentRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        if #available(iOS 10.0, *) {
            if UIScreen.main.traitCollection.displayGamut == .P3 {
                self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
            } else {
                self.init(red: red, green: green, blue: blue, alpha: alpha)
            }
        } else {
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    @available(iOS 10.0, *)
    internal convenience init(displayP3Hue hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        let converter = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        converter.getRed(&red, green: &green, blue: &blue, alpha: nil)

        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }

    internal convenience init(deviceDependentHue hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        if #available(iOS 10.0, *) {
            if UIScreen.main.traitCollection.displayGamut == .P3 {
                self.init(displayP3Hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            } else {
                self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            }
        } else {
            self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
    }

    internal var convertedToP3Values: UIColor {
        if #available(iOS 10.0, *) {
            if UIScreen.main.traitCollection.displayGamut == .P3 {
                if let p3ColorSpace = CGColorSpace(name: CGColorSpace.displayP3),
                    let convertedColor = cgColor.converted(to: p3ColorSpace, intent: .defaultIntent, options: nil) {
                    return UIColor(cgColor: convertedColor)
                }
            }
        }

        return self
    }
}
