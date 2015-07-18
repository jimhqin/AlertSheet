//
//  RootViewController.swift
//  AlertSheetDemo
//
//  Created by JQ@Onbeep on 7/17/15.
//  Copyright (c) 2015 jimqin. All rights reserved.
//

import UIKit

struct DemoButtonAppearance {
    static let width                    = 200
    static let height                   = 44
    static let topMargin                = 44

    static let cornerRadius: CGFloat    = 11.0
}

final class RootViewController: UIViewController, AlertSheetDelegate {

    override func loadView() {
        let applicationFrame = UIScreen.mainScreen().applicationFrame
        let contentView = UIView(frame: applicationFrame)
        contentView.backgroundColor = UIColor.whiteColor()
        view = contentView

        let demoButton = DemoButton(frame: CGRect.zeroRect)
        demoButton.addTarget(self, action: "didPressDemoButton", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(demoButton)

        demoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        let viewsDictionary = ["demoButton": demoButton]

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[demoButton(\(DemoButtonAppearance.width))]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        )
        view.addConstraints(horizontalConstraints)

        let centerHorizontallyStoryView = centerHorizontallyConstraint(forView: viewsDictionary["demoButton"]!)
        view.addConstraint(centerHorizontallyStoryView)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-\(DemoButtonAppearance.topMargin)-[demoButton(\(DemoButtonAppearance.height))]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        )
        view.addConstraints(verticalConstraints)
    }

    func didPressDemoButton() {
        if view.viewWithTag(1) != nil {
            return
        }

        let alertSheet = AlertSheet(
            title: "Network Error",
            message: "You appear to be offline. Check your connection and try again.",
            buttonTitle: "DISMISS",
            image: nil
        )
        alertSheet.delegate = self
        alertSheet.tag = 1
        alertSheet.showInView(view)
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

    // MARK: - AlertSheetDelegate Protocol

    func alertSheet(alertSheet: AlertSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0: alertSheet.dismiss()
        default: alertSheet.dismiss()
        }
    }
}

