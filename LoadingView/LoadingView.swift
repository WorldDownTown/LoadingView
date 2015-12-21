//
//  LoadingView.swift
//  LoadingView
//
//  Created by shoji on 2015/12/21.
//  Copyright © 2015年 com.shoji. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    private static let sharedView = LoadingView()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    private let messageLabel = UILabel()
    private let reloadButton = UIButton(type: .System)
    private var reloadButtonPressedBlock: (Void -> Void)?
    override var tintColor: UIColor! {
        didSet {
            activityIndicatorView.color = tintColor
            reloadButton.tintColor = tintColor
        }
    }

    convenience init() {
        self.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
        translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
        translatesAutoresizingMaskIntoConstraints = true
    }
}


// MARK: - private methods

extension LoadingView {

    private func sharedInit() {
        setupIndicator()
        setupLabel()
        setupButton()
        tintColor = UIColor(red: (241.0 / 255.0), green: (82.0 / 255.0), blue: (163.0 / 255.0), alpha: 1.0)
    }

    private func setupIndicator() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)

        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: activityIndicatorView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Top, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: activityIndicatorView, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: activityIndicatorView, attribute: .Trailing, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: activityIndicatorView, attribute: .Bottom, multiplier: 1.0, constant: 8.0),
        ]
        addConstraints(constraints)
    }

    private func setupLabel() {
        messageLabel.hidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 2
        addSubview(messageLabel)

        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: messageLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 15.0),
            NSLayoutConstraint(item: messageLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: messageLabel, attribute: .Trailing, multiplier: 1.0, constant: 8.0),
        ]
        addConstraints(constraints)
    }

    private func setupButton() {
        reloadButton.hidden = true
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitle("再読込", forState: .Normal)
        reloadButton.addTarget(self, action: "reloadButtonTouchUpInside", forControlEvents: .TouchUpInside)
        addSubview(reloadButton)

        var constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: messageLabel, attribute: .Bottom, relatedBy: .Equal, toItem: reloadButton, attribute: .Top, multiplier: 1.0, constant: 15.0),
            NSLayoutConstraint(item: reloadButton, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: reloadButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: reloadButton, attribute: .Trailing, multiplier: 1.0, constant: 8.0),
        ]

        let bottom = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: reloadButton, attribute: .Bottom, multiplier: 1.0, constant: 15.0)
        bottom.priority = UILayoutPriorityDefaultHigh
        constraints.append(bottom)

        addConstraints(constraints)
    }

    @objc private func reloadButtonTouchUpInside() {
        reloadButtonPressedBlock?()
    }

    private static func addSharedViewWithAdditionalY(additionalY: CGFloat) {
        let screenBounds = UIScreen.mainScreen().bounds
        let width = screenBounds.width
        let height: CGFloat = 120.0
        let y: CGFloat = (screenBounds.height - height) / 2.0 + additionalY
        sharedView.frame = CGRectMake(0.0, y, width, height)
        UIApplication.sharedApplication().keyWindow?.addSubview(sharedView)
    }
}


// MARK: - Public methods

extension LoadingView {

    func show() {
        hidden = false
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
        messageLabel.hidden = true
        reloadButton.hidden = true
        reloadButtonPressedBlock = nil
    }

    func dismiss() {
        hidden = true
        activityIndicatorView.hidden = true
        activityIndicatorView.stopAnimating()
        messageLabel.hidden = true
        reloadButton.hidden = true
        reloadButtonPressedBlock = nil
    }

    func showMessage(message: String, reloadButtonPressedBlock: (Void -> Void)?) {
        hidden = false
        activityIndicatorView.hidden = true
        activityIndicatorView.stopAnimating()
        messageLabel.hidden = false
        messageLabel.text = message
        reloadButton.hidden = false
        self.reloadButtonPressedBlock = reloadButtonPressedBlock
    }

    static func showWithAdditionalY(additionalY: CGFloat) {
        addSharedViewWithAdditionalY(additionalY)
        sharedView.show()
    }

    static func show() {
        showWithAdditionalY(0.0)
    }

    static func dismiss() {
        sharedView.dismiss()
        sharedView.removeFromSuperview()
    }

    static func showMessage(message: String, additionalY: CGFloat, reloadButtonPressedBlock: (Void -> Void)?) {
        addSharedViewWithAdditionalY(additionalY)
        sharedView.showMessage(message, reloadButtonPressedBlock: reloadButtonPressedBlock)
    }

    static func showMessage(message: String, reloadButtonPressedBlock: (Void -> Void)?) {
        showMessage(message, additionalY: 0.0, reloadButtonPressedBlock: reloadButtonPressedBlock)
    }
}
