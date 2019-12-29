//
//  FormViewController.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 29/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    public lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = .never
        }
        sv.contentSize = view.frame.size
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    public let formContainerStackView: UIStackView = {
        let sv = UIStackView()
        sv.isLayoutMarginsRelativeArrangement = true
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let alignment: FormAlignment
    
    public init(alignment: FormAlignment = .top) {
        self.alignment = alignment
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("You most likely have a Storyboard controller that uses this class, please remove any instance of FormController or sublasses of this component from your Storyboard files.")
        self.alignment = .top
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(formContainerStackView)
        
        if alignment == .top {
            formContainerStackView.anchor(top: scrollView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        } else {
            formContainerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            formContainerStackView.centerInSuperview()
        }
        
        setupKeyboardNotifications()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if formContainerStackView.frame.height > scrollView.frame.height {
            scrollView.contentSize.height = formContainerStackView.frame.size.height
        }
    }
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        scrollView.contentInset.bottom = keyboardFrame.height
        
        // When stackView is center aligned, need some extra bottom padding
        if alignment == .center {
            scrollView.contentInset.bottom += UIApplication.shared.statusBarFrame.height
        }
        
        // Correct for scroll view height + add spacing above keyboard = formContainerStackView.spacing
        scrollView.contentInset.bottom -= view.frame.height - scrollView.frame.height - scrollView.frame.origin.y - formContainerStackView.spacing

        scrollView.scrollIndicatorInsets.bottom = keyboardFrame.height - (view.frame.height - scrollView.frame.height - scrollView.frame.origin.y)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    public enum FormAlignment {
        case top, center
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
