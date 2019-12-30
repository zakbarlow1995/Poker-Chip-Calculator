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

class SaturationBrightnessPickerView: UIControl {

    // MARK: - Properties

    var displayedHue = ExtendedSRGBValue(0) {
        didSet {
            if oldValue != displayedHue {
                setNeedsDisplay()
            }
        }
    }

    var pickedSaturation = DisplayP3Value(0)
    var pickedBrightness = DisplayP3Value(0)

    private let markerView = UIView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        configureMarkerView()

        isOpaque = false
        backgroundColor = .clear
        clipsToBounds = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(panned(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))

        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Configuration

    private func configureMarkerView() {
        markerView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        markerView.backgroundColor = .clear
        markerView.center = .zero

        markerView.layer.borderColor = UIColor.white.cgColor
        markerView.layer.borderWidth = 2.0
        markerView.layer.cornerRadius = 10
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        markerView.layer.shadowOpacity = 0.25
        markerView.layer.shadowRadius = 2

        addSubview(markerView)
    }

    // MARK: - UIView

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.addRoundedRect(of: bounds.size, cornerRadius: CGSize(width: 2, height: 2))
        context.clip()

        let colorSpace = CGColorSpace.p3OrDeviceRGB
        let horizontalColors = [
            UIColor(deviceDependentRed: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(hue: CGFloat(displayedHue.value), saturation: 1, brightness: 1, alpha: 1).cgColor
        ]

        if let horizontalGradient = CGGradient(colorsSpace: colorSpace, colors: horizontalColors as CFArray, locations: [0, 1]) {
            context.drawLinearGradient(horizontalGradient, start: .zero, end: CGPoint(x: bounds.maxX, y: 0), options: [])
        }

        let verticalColors = [
            UIColor(deviceDependentRed: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(deviceDependentRed: 0, green: 0, blue: 0, alpha: 1).cgColor
        ]

        if let verticalGradient = CGGradient(colorsSpace: colorSpace, colors: verticalColors as CFArray, locations: [0, 1]) {
            context.drawLinearGradient(verticalGradient, start: .zero, end: CGPoint(x: 0, y: bounds.maxY), options: [])
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    // MARK: - Actions

    @objc private func panned(_ gestureRecognizer: UIGestureRecognizer) {
        var position = gestureRecognizer.location(in: self)
        position.x = max(bounds.minX, min(position.x, bounds.maxX))
        position.y = max(bounds.minY, min(position.y, bounds.maxY))

        markerView.center = position

        let saturation = Double(position.x / bounds.width)
        let brightness = Double(1 - position.y / bounds.height)

        pickedSaturation = DisplayP3Value(saturation)
        pickedBrightness = DisplayP3Value(brightness)

        sendActions(for: .valueChanged)
    }

    // MARK: - Marker

    internal func updateMarkerPosition() {
        let xPosition = CGFloat(pickedSaturation.value) * bounds.width
        let yPosition = bounds.height - CGFloat(pickedBrightness.value) * bounds.height

        markerView.center = CGPoint(
            x: max(0, min(bounds.maxX, xPosition)),
            y: max(0, min(bounds.maxY, yPosition))
        )
    }

}
