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

import UIKit

class AlphaPickerView: PickerView {

    // MARK: - Properties

    var displayedColor = UIColor.white {
        didSet {
            if oldValue != displayedColor {
                setNeedsDisplay()
            }
        }
    }

    var pickedAlpha = CGFloat(0)

    // MARK: - UIView

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.addRoundedRect(of: bounds.size, cornerRadius: CGSize(width: 2, height: 2))
        context.clip()

        context.setFillColor((UIColor.transparentPattern ?? UIColor.clear).cgColor)
        context.fill(bounds)

        let colorSpace = CGColorSpace.p3OrDeviceRGB
        let colors = [
            displayedColor.withAlphaComponent(0).cgColor,
            displayedColor.withAlphaComponent(1).cgColor
        ]

        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1]) {
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0, y: bounds.maxY), options: [])
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    // MARK: - PickerView

    override func updatePosition(to point: CGPoint) {
        super.updatePosition(to: point)

        pickedAlpha = point.y / bounds.height
        sendActions(for: .valueChanged)
    }

    override func updateMarkerPosition() {
        super.updateMarkerPosition()

        markerView.center.y = max(0, min(bounds.maxY, pickedAlpha * bounds.height))
    }
}
