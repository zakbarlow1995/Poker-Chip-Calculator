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

class PickerView: UIControl {

    // MARK: - Properties

    internal let markerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 4)))

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
        markerView.backgroundColor = .white
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        markerView.layer.shadowOpacity = 0.25
        markerView.layer.shadowRadius = 2
        addSubview(markerView)

        isOpaque = false
        backgroundColor = .clear
        clipsToBounds = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(panned(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))

        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        markerView.bounds.size.width = bounds.width * 1.5
        markerView.center.x = bounds.midX
    }

    // MARK: - Actions

    @objc private func panned(_ gestureRecognizer: UIGestureRecognizer) {
        var position = gestureRecognizer.location(in: self)
        position.y = max(bounds.minY, min(position.y, bounds.maxY))
        updatePosition(to: position)
        markerView.center.y = position.y
    }

    // MARK: - Internals

    internal func updatePosition(to point: CGPoint) {
    }

    internal func updateMarkerPosition() {
    }

}
