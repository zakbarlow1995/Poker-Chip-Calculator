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

/// The `ColorPickerView` provides a way to pick colors.
/// It contains three elements - a hue picker, a brightness and saturation picker and an alpha
/// picker. It has full support for wide colors.
@IBDesignable @objc(IMGLYColorPickerView) open class ColorPickerView: UIControl {

    // MARK: - Properties

    /// The currently selected color
    @IBInspectable public var color: UIColor {
        get {
            return UIColor(
                deviceDependentHue: CGFloat(huePickerView.pickedHue.value),
                saturation: CGFloat(saturationBrightnessPickerView.pickedSaturation.value),
                brightness: CGFloat(saturationBrightnessPickerView.pickedBrightness.value),
                alpha: alphaPickerView.pickedAlpha
            )
        }

        set {
            if color != newValue {
                let hsb = newValue.hsb

                // Note: These values are actually in P3 color space now, so we can use them for `pickedHue`, `pickedBrightness` and `pickedSaturation` despite not matching types
                let p3HSB = newValue.convertedToP3Values.hsb

                huePickerView.pickedHue = DisplayP3Value(p3HSB.hue.value)

                saturationBrightnessPickerView.displayedHue = hsb.hue
                saturationBrightnessPickerView.pickedBrightness = DisplayP3Value(p3HSB.brightness.value)
                saturationBrightnessPickerView.pickedSaturation = DisplayP3Value(p3HSB.saturation.value)

                var alpha: CGFloat = 0
                newValue.getWhite(nil, alpha: &alpha)
                alphaPickerView.displayedColor = newValue
                alphaPickerView.pickedAlpha = alpha

                updateMarkersToMatchColor()
            }
        }
    }

    private let huePickerView = HuePickerView()
    private let saturationBrightnessPickerView = SaturationBrightnessPickerView()
    private let alphaPickerView = AlphaPickerView()

    // MARK: - Initializers

    /// :nodoc:
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        configureHuePickerView()
        configureSaturationBrightnessPickerView()
        configureAlphaPickerView()
        configureConstraints()
    }

    // MARK: - Configuration

    private func configureHuePickerView() {
        huePickerView.translatesAutoresizingMaskIntoConstraints = false
        huePickerView.addTarget(self, action: #selector(huePickerChanged(_:)), for: .valueChanged)
        addSubview(huePickerView)
    }

    private func configureSaturationBrightnessPickerView() {
        saturationBrightnessPickerView.translatesAutoresizingMaskIntoConstraints = false
        saturationBrightnessPickerView.addTarget(self, action: #selector(saturationBrightnessPickerChanged(_:)), for: .valueChanged)
        addSubview(saturationBrightnessPickerView)
    }

    private func configureAlphaPickerView() {
        alphaPickerView.translatesAutoresizingMaskIntoConstraints = false
        alphaPickerView.addTarget(self, action: #selector(alphaPickerChanged(_:)), for: .valueChanged)
        addSubview(alphaPickerView)
    }

    private func configureConstraints() {
        let views = [
            "saturationBrightnessPickerView": saturationBrightnessPickerView,
            "huePickerView": huePickerView,
            "alphaPickerView": alphaPickerView,
        ]

        var constraints = [NSLayoutConstraint]()

        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[saturationBrightnessPickerView]-20-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[huePickerView(==saturationBrightnessPickerView)]-20-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[alphaPickerView(==saturationBrightnessPickerView)]-20-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-12-[huePickerView(20)]-12-[saturationBrightnessPickerView]-12-[alphaPickerView(20)]-12-|", options: [], metrics: nil, views: views))

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - UIView

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateMarkersToMatchColor()
    }

    // MARK: - Actions

    @objc private func huePickerChanged(_ huePickerView: HuePickerView) {
        let color = self.color
        saturationBrightnessPickerView.displayedHue = color.hsb.hue
        alphaPickerView.displayedColor = color
        sendActions(for: .valueChanged)
    }

    @objc private func alphaPickerChanged(_ alphaPickerView: AlphaPickerView) {
        sendActions(for: .valueChanged)
    }

    @objc private func saturationBrightnessPickerChanged(_ saturationBrightnessPicker: SaturationBrightnessPickerView) {
        alphaPickerView.displayedColor = color
        sendActions(for: .valueChanged)
    }

    // MARK: - Markers

    private func updateMarkersToMatchColor() {
        huePickerView.updateMarkerPosition()
        saturationBrightnessPickerView.updateMarkerPosition()
        alphaPickerView.updateMarkerPosition()
    }
}
