//
//  AlertSheetButton.swift
//  OnBeep
//
//  Created by JQ@Onbeep on 2/27/15.
//  Copyright (c) 2015 OnBeep, Inc. All rights reserved.
//

import UIKit

class AlertSheetButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureAppearance()
    }

    convenience init() {
        self.init(frame: CGRect.zeroRect)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        backgroundColor = UIColor(red: 112/255.0, green: 206/255.0, blue: 216/255.0, alpha: 1.0)
        opaque = true
        setBackgroundImage(UIImage(named: "btn-connect"), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: "btn-connect-tap"), forState: UIControlState.Highlighted)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.0
        showsTouchWhenHighlighted = true
    }
}
