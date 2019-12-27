//
//  UIViewControllerExtensions.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
    
    // https://stackoverflow.com/a/44175947/10623169
    func hasUIAlertBeenPresented() -> Bool {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            if topController is UIAlertController {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

//Navigation/status bar extensions
extension UIViewController {
    //https://stackoverflow.com/a/48684198/10623169
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topBarTotalHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0.0 // Tab bar height should be: 49.0
    }
    
    func setupTransparentNavigationBarWithBlackText() {
        setupTransparentNavigationBar()
        //Status bar text and back(item) tint to black
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func setupTransparentNavigationBarWithWhiteText() {
        setupTransparentNavigationBar()
        //Status bar text and back(item) tint to white
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

// iPhone X+ detection - https://stackoverflow.com/a/47067296/10623169 - "You shall perform different detections of iPhone X depending on the actual need"
extension UIApplication {
    
    //for dealing with the top notch (statusbar, navbar), etc.
    class var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
            // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }
    
    //for dealing with the bottom home indicator (tabbar), etc.
    class var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
            // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
    
    class var bottomSafeAreaInsetHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        } else {
            return 0.0
        }
    }
    
    class var topSafeAreaInsetHeight: CGFloat {
        if #available(iOS 11.0, *) {
            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
            // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
            return max(UIDevice.current.userInterfaceIdiom == .pad ? UIApplication.shared.statusBarFrame.size.height : UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 20, 20)
        } else {
            return 20.0
        }
    }
    
    //for backgrounds size, fullscreen features, etc.
    class var isIphoneXOrBigger: Bool {
        // 812.0 on iPhone X, XS.
        // 896.0 on iPhone XS Max, XR.
        return UIScreen.main.bounds.height >= 812
    }
    
    //for backgrounds ratio, scrolling features, etc.
    class var isIphoneXOrLonger: Bool {
        // 812.0 / 375.0 on iPhone X, XS.
        // 896.0 / 414.0 on iPhone XS Max, XR.
        return UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 896.0 / 414.0
    }
    
    //for analytics, stats, tracking, etc.
    class var isIphoneX: Bool {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let model = String(cString: machine)
        return model == "iPhone10,3" || model == "iPhone10,6"
    }
}
