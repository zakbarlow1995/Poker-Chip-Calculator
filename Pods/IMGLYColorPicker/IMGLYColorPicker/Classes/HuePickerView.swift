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

class HuePickerView: PickerView {

    // MARK: - Properties

    var pickedHue = DisplayP3Value(0)

    // MARK: - UIView

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.addRoundedRect(of: bounds.size, cornerRadius: CGSize(width: 2, height: 2))
        context.clip()

        let colorSpace = CGColorSpace.p3OrDeviceRGB
        let step = CGFloat(0.166666666666667)
        let locations: [CGFloat] = [0.0, step, step * 2, step * 3, step * 4, step * 5, 1.0]
        let colors = [
            UIColor(deviceDependentRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 1.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 0.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 1.0, green: 1.0, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(deviceDependentRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        ]

        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) {
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

        let hue = 1 - (point.y / bounds.height)
        pickedHue = DisplayP3Value(Double(hue))
        sendActions(for: .valueChanged)
    }

    override func updateMarkerPosition() {
        super.updateMarkerPosition()

        markerView.center.y = max(0, min(bounds.maxY, bounds.height - CGFloat(pickedHue.value) * bounds.height))
    }
}
