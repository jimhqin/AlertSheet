//
//  AlertSheet.swift
//  OnBeep
//
//  Created by JQ@Onbeep on 2/23/15.
//  Copyright (c) 2015 OnBeep, Inc. All rights reserved.
//

import UIKit

@objc protocol AlertSheetDelegate {
    /**
    Sent to the delegate when the user clicks a button on an alert sheet.

    :param: alertSheet  The alert sheet containing the button.
    :param: buttonIndex The position of the clicked button. The button indices start at 0.
    */
    optional func alertSheet(alertSheet: AlertSheet, clickedButtonAtIndex buttonIndex: Int)

    /**
    Sent to the delegate after an alert sheet is dismissed.

    :param: alertSheet The alert sheet that is dismissed.
    */
    optional func alertSheetDidDismiss(alertSheet: AlertSheet)
}

struct Tags {
    static let imageView: Int                   = 1
    static let titleLabel: Int                  = 2
    static let messageLabel: Int                = 3
    static let button: Int                      = 4
}

private struct AlertSheetBounds {
    static let sheetHeight: CGFloat             = 94.0
    static let sheetWithButtonHeight: CGFloat   = 134.0
    static let curveHeight: CGFloat             = 18.0
}

private struct ImageViewBounds {
    static let width: CGFloat                   = 19.0
    static let height: CGFloat                  = 18.0
}

private struct TitleLabelBounds {
    static let maxWidth: CGFloat                = 280.0
    static let maxHeight: CGFloat               = 20.0
}

private struct MessageLabelBounds {
    static let maxWidth: CGFloat                = 235.0
    static let maxHeight: CGFloat               = 34.0
}

private struct ButtonBounds {
    static let width: CGFloat                   = 200.0
    static let height: CGFloat                  = 30.0
}

private struct SubviewMargins {
    static let viewTopToImage: CGFloat          = 5.0
    static let viewTopToTitle: CGFloat          = 28.0
    static let viewTopToMessage: CGFloat        = 53.0
    static let viewTopToButton: CGFloat         = 91.0
}

private struct AlertSheetAnimation {
    static let duration: NSTimeInterval         = 0.3
    static let delay: NSTimeInterval            = 0.0
    static let damping: CGFloat                 = 1.0
    static let velocity: CGFloat                = 1.0
}

/**
An AlertSheet object displays an alert sheet to the user. After initializing the alert sheet and adding it to a navigation controller's view hierachy, present it using the showInView() method.
*/
class AlertSheet: UIView {

    /// The background color of the alert sheet.
    var sheetColor: UIColor {
        get {
            return _sheetColor
        }

        set(newColor) {
            _sheetColor = newColor

            let titleLabel = self.viewWithTag(Tags.titleLabel)
            titleLabel?.backgroundColor = newColor

            let messageLabel = self.viewWithTag(Tags.messageLabel)
            messageLabel?.backgroundColor = newColor

            let button = self.viewWithTag(Tags.button)
            button?.backgroundColor = newColor
        }
    }

    private var _sheetColor: UIColor = UIColor(red: 112/255.0, green: 206/255.0, blue: 216/255.0, alpha: 1.0) // Default sheet color

    /// The font for all of the alert sheet elements. The default is the system font size 13.
    var sheetFont: UIFont {
        get {
            return _sheetFont
        }

        set(newFont) {
            _sheetFont = newFont

            let titleLabel = self.viewWithTag(Tags.titleLabel) as? UILabel
            titleLabel?.font = newFont

            let messageLabel = self.viewWithTag(Tags.messageLabel) as? UILabel
            messageLabel?.font = newFont

            let button = self.viewWithTag(Tags.button) as? UIButton
            button?.titleLabel?.font = newFont
        }
    }

    private var _sheetFont: UIFont = UIFont.systemFontOfSize(13.0) // Default sheet font

    /// The receiver's delegate or nil if it doesn't have a delegate
    var delegate: AlertSheetDelegate?

    // MARK: - Drawings

    override func drawRect(rect: CGRect) {
        drawAlertSheetRect(rect)
    }

    private func drawAlertSheetRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        drawBottomRect(context, rect: rect)
        drawTopCurve(context, rect: rect)
        fillBackgroundColor(context, rect: rect)
        CGContextFillPath(context)
    }

    private func drawBottomRect(context: CGContextRef, rect: CGRect) {
        CGContextMoveToPoint(context, 0.0, AlertSheetBounds.curveHeight)
        CGContextAddLineToPoint(context, 0.0, rect.size.height)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height)
        CGContextAddLineToPoint(context, rect.size.width, AlertSheetBounds.curveHeight)
    }

    private func drawTopCurve(context: CGContextRef, rect: CGRect) {
        CGContextAddQuadCurveToPoint(
            context,
            rect.size.width/2,
            -AlertSheetBounds.curveHeight,
            0.0,
            AlertSheetBounds.curveHeight
        )
    }

    private func fillBackgroundColor(context: CGContextRef, rect: CGRect) {
        CGContextSetFillColorWithColor(context, sheetColor.CGColor)
    }

    // MARK: - Initializers

    /**
    Designated intializer for intializing an alert sheet.

    :param: title       The string that appears in the alert sheet's title area or nil if there is no title.
    :param: message     Descriptive text that provides more details than the title or nil if there is no descriptive text.
    :param: buttonTitle The title of the action button or nil if there is no action button.
    :param: image       The image that appears above the alert sheet's title area or nil of there is no image.

    :returns: Newly initialized alert sheet.
    */
    init(title: String?, message: String?, buttonTitle: String?, image: UIImage?) {
        let defaultWidth = UIScreen.mainScreen().bounds.width
        let defaultHeight = (buttonTitle != nil) ? AlertSheetBounds.sheetWithButtonHeight : AlertSheetBounds.sheetHeight
        let defaultY = UIScreen.mainScreen().bounds.height
        let defaultFrame = CGRectMake(0.0, defaultY, defaultWidth, defaultHeight)

        super.init(frame: defaultFrame)

        configureSheetAppearance()

        var viewsDictionary = [NSObject: AnyObject]()

        if let anImage = image {
            let anImageView = imageView(anImage)
            addSubview(anImageView)
            viewsDictionary["imageView"] = anImageView
        }

        if let aTitle = title {
            let aTitleLabel = titleLabel(aTitle)
            addSubview(aTitleLabel)
            viewsDictionary["titleLabel"] = aTitleLabel
        }

        if let aMessage = message {
            let aMessageLabel = messageLabel(aMessage)
            addSubview(aMessageLabel)
            viewsDictionary["messageLabel"] = aMessageLabel
        }

        if let aButtonTitle = buttonTitle {
            let aButton = button(aButtonTitle)
            addSubview(aButton)
            viewsDictionary["button"] = aButton
        }

        if !viewsDictionary.isEmpty {
            configureContraints(forViews: viewsDictionary)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSheetAppearance() {
        backgroundColor = UIColor.clearColor()
        alpha = 0.0
        hidden = true
    }

    // MARK: - AutoLayout Constraints

    private func configureContraints(forViews views: [NSObject: AnyObject]) {
        for view in views.values {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }

        // ImageView

        if let imageView = views["imageView"] as? UIImageView {
            let topSpaceToSuperview = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-\(SubviewMargins.viewTopToImage)-[imageView(==\(ImageViewBounds.height))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(topSpaceToSuperview)

            let imageViewConstantWidth = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[imageView(==\(ImageViewBounds.width))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(imageViewConstantWidth)

            let imageViewCenterHorizontally = centerHorizontallyConstraint(forView: imageView)
            addConstraint(imageViewCenterHorizontally)
        }

        // TitleLabel

        if let titleLabel = views["titleLabel"] as? UILabel {
            let topSpaceToSuperview = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-\(SubviewMargins.viewTopToTitle)-[titleLabel(==\(TitleLabelBounds.maxHeight))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(topSpaceToSuperview)

            let constantWidth = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[titleLabel(==\(TitleLabelBounds.maxWidth))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(constantWidth)

            let centerHorizontally = centerHorizontallyConstraint(forView: titleLabel)
            addConstraint(centerHorizontally)
        }

        // MessageLabel

        if let messageLabel = views["messageLabel"] as? UILabel {
            let topSpaceToSuperview = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-\(SubviewMargins.viewTopToMessage)-[messageLabel(==\(MessageLabelBounds.maxHeight))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(topSpaceToSuperview)

            let messageLabelConstantWidth = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[messageLabel(==\(MessageLabelBounds.maxWidth))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(messageLabelConstantWidth)

            let messageLabelCenterHorizontally = centerHorizontallyConstraint(forView: messageLabel)
            addConstraint(messageLabelCenterHorizontally)
        }

        // Button

        if let button = views["button"] as? UIButton {
            let topSpaceToSuperview = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-\(SubviewMargins.viewTopToButton)-[button(==\(ButtonBounds.height))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(topSpaceToSuperview)

            let buttonConstantWidth = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[button(==\(ButtonBounds.width))]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: views
            )
            addConstraints(buttonConstantWidth)

            let buttonCenterHorizontally = centerHorizontallyConstraint(forView: button)
            addConstraint(buttonCenterHorizontally)
        }
    }

    private func centerHorizontallyConstraint(forView view: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view.superview!,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0
        )

        return constraint
    }

    // MARK: - Image

    private func imageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.Center
        imageView.backgroundColor = sheetColor
        imageView.opaque = true
        imageView.tag = Tags.imageView

        return imageView
    }

    // MARK: - Title Label

    private func titleLabel(title: String) -> UILabel {
        let titleLabel = AlertSheetLabel()
        titleLabel.backgroundColor = sheetColor
        titleLabel.font = sheetFont
        titleLabel.numberOfLines = 1
        titleLabel.tag = Tags.titleLabel
        titleLabel.text = title

        return titleLabel
    }

    // MARK: - Message Label

    private func messageLabel(message: String) -> UILabel {
        let messageLabel = AlertSheetLabel()
        messageLabel.tag = Tags.messageLabel
        messageLabel.font = sheetFont
        messageLabel.text = message

        return messageLabel
    }

    // MARK: - Button

    private func button(title: String) -> UIButton {
        let button = AlertSheetButton()
        button.backgroundColor = sheetColor
        button.titleLabel?.font = sheetFont
        button.addTarget(self, action: "didPressButton:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle(title, forState: UIControlState.Normal)
        button.tag = Tags.button

        return button
    }

    func didPressButton(sender: AnyObject) {
        delegate?.alertSheet?(self, clickedButtonAtIndex: 0)
    }

    // MARK: - Public Methods

    /**
    Displays an alert sheet with animation that originates from the specified view.

    :param: view The view from which the alert sheet originates
    */
    func showInView(view: UIView) {
        if !self.hidden {
            return
        }

        view.addSubview(self)
        animateSheetIn()
    }

    /**
    Dismisses the alert sheet immediately with animation.
    */
    func dismiss() {
        if self.hidden {
            return
        }

        animateSheetOut()
    }

    private func animateSheetIn() {
        UIView.animateWithDuration(
            AlertSheetAnimation.duration,
            delay: AlertSheetAnimation.delay,
            usingSpringWithDamping: AlertSheetAnimation.damping,
            initialSpringVelocity: AlertSheetAnimation.velocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.frame = self.showFrame()
                self.alpha = 1.0
            }, completion: nil)
    }

    private func showFrame() -> CGRect {
        hidden = false
        var newFrame = self.frame
        newFrame.origin.y = UIScreen.mainScreen().bounds.height - newFrame.size.height

        return newFrame
    }

    private func animateSheetOut() {
        UIView.animateWithDuration(
            AlertSheetAnimation.duration,
            delay: AlertSheetAnimation.delay,
            usingSpringWithDamping: AlertSheetAnimation.damping,
            initialSpringVelocity: AlertSheetAnimation.velocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.frame = self.dismissFrame()
                self.alpha = 0.0
            }) { (finished: Bool) -> Void in
                if finished {
                    self.hidden = true
                    self.delegate?.alertSheetDidDismiss?(self)
                    self.removeFromSuperview()
                }
            }
    }

    private func dismissFrame() -> CGRect {
        var newFrame = self.frame
        newFrame.origin.y = UIScreen.mainScreen().bounds.height

        return newFrame
    }
}
