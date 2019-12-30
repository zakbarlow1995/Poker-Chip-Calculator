# IMGLYColorPicker

[![CI Status](http://img.shields.io/travis/imgly/IMGLYColorPicker.svg?style=flat)](https://travis-ci.org/imgly/IMGLYColorPicker)
[![Version](https://img.shields.io/cocoapods/v/IMGLYColorPicker.svg?style=flat)](http://cocoapods.org/pods/IMGLYColorPicker)
[![License](https://img.shields.io/cocoapods/l/IMGLYColorPicker.svg?style=flat)](http://cocoapods.org/pods/IMGLYColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/IMGLYColorPicker.svg?style=flat)](http://cocoapods.org/pods/IMGLYColorPicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

IMGLYColorPicker is written in Swift 3, so it requires Xcode 8. It is completely compatible with Objective-C and supports iOS 9 and above.

## Installation

IMGLYColorPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IMGLYColorPicker"
```

## Usage

Instantiate a `ColorPickerView` instance (or `IMGLYColorPickerView` if using Objective-C) and add it to your view hierachy:

```swift
let colorPickerView = ColorPickerView()
view.addSubview(colorPickerView)
```

Set the initially displayed color of the color picker:

```swift
colorPickerView.color = UIColor.red
```

Register yourself as a target to receive `.valueChanged` events whenever the selected color changes:

```swift
colorPickerView.addTarget(self, action: #selector(colorPicked(_:)), for: .valueChanged)
```

![](./screenshot.png)

## Author

9elements GmbH, contact@9elements.com

## License

IMGLYColorPicker is available under the MIT license. See the LICENSE file for more info.
